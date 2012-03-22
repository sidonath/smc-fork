/*
 * Created on Dec 31, 2004
 */
package net.sf.smc.ant;

import java.io.File;
import java.util.*;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.taskdefs.Java;
import org.apache.tools.ant.types.EnumeratedAttribute;
import org.apache.tools.ant.types.Path;
import org.apache.tools.ant.types.Reference;

/**
 * <smc 
 *   target="java|graph|table.." 
 *   smfile="Turnstyle.sm"
 *   destdir="${build.classes.dir}"
 *   reflect="true|false"
 *   smcjar="bin/Smc.jar"
 *   suffix="jav"
 *   sync="true|false"
 *   serial="true|false"
 *   g="true|false"
 *   glevel="0|1|2" />
 * 
 * @author Eitan Suez
 * @author Ernest Hill
 */
public class SmcJarWrapper extends Task
{
   private Path _classpath;
   private File _smfile;
   private File _destdir;
   private String _target;
   private File _smcjar;
   private String _suffix;
   private boolean _reflect, _sync, _serial, _g;
   private String _glevel;
   
   private static Map<String, String> DEFAULT_SUFFIXES =
       new HashMap<String, String>();
   static
   {
     DEFAULT_SUFFIXES.put("c", "c");
     DEFAULT_SUFFIXES.put("c++", "cpp");
     DEFAULT_SUFFIXES.put("csharp", "cs");
     DEFAULT_SUFFIXES.put("graph", "dot");
     DEFAULT_SUFFIXES.put("groovy", "groovy");
     DEFAULT_SUFFIXES.put("java", "java");
     DEFAULT_SUFFIXES.put("lua", "lua");
     DEFAULT_SUFFIXES.put("objc", "m");
     DEFAULT_SUFFIXES.put("perl", "pl");
     DEFAULT_SUFFIXES.put("php", "php");
     DEFAULT_SUFFIXES.put("python", "py");
     DEFAULT_SUFFIXES.put("ruby", "rb");
     DEFAULT_SUFFIXES.put("scala", "scala");
     DEFAULT_SUFFIXES.put("table", "html");
     DEFAULT_SUFFIXES.put("tcl", "tcl");
     DEFAULT_SUFFIXES.put("vb", "vb");
   }
   
   public void setClasspath(Path classpath)
   {
      _classpath = classpath;
   }
   public void setClasspathRef(Reference ref)
   {
      createClasspath().setRefid(ref);
   }
   public Path createClasspath()
   {
      if (_classpath == null)
      {
         _classpath = new Path(this.getProject());
      }
      return _classpath.createPath();
   }
   
   public void setSmfile(File smfile)
   {
      _smfile = smfile;
      deriveStemname();
   }
   
   private String _stemname = "";
   private void deriveStemname()
   {
      String smfilename = _smfile.getName();
      int idx = smfilename.lastIndexOf(".sm");
      _stemname = smfilename.substring(0, idx);
   }
   
   public void setDestdir(File destdir)
   {
      _destdir = destdir;
   }
   public void setTarget(TargetEnum target)
   {
      _target = target.getValue();
   }
   
   public void setSmcjar(File jar)
   {
      _smcjar = jar;
   }

   public void setReflect(boolean reflect) { _reflect = reflect; }
   public void setSync(boolean sync) { _sync = sync; }
   public void setSerial(boolean serial) { _serial = serial; }
   public void setG(boolean g) { _g = g; }
   
   public void setGlevel(String glevel) { _glevel = glevel; }
   
   public void setSuffix(String suffix) { _suffix = suffix; }

   
   private static String[] TARGET_OPTIONS = 
   {
       "c",
       "c++",
       "csharp",
       "graph",
       "groovy",
       "java",
       "lua",
       "objc",
       "perl",
       "php",
       "python",
       "ruby",
       "scala",
       "table",
       "tcl",
       "vb"
   };
   
   public static class TargetEnum extends EnumeratedAttribute
   {
      public String[] getValues() { return TARGET_OPTIONS; }
   }
   
   public void execute()
   {
      validateParameters();
      
      File parent = (_destdir == null) ? 
            _smfile.getParentFile() : _destdir;
      String suffix = (_suffix == null) ? 
            (String) DEFAULT_SUFFIXES.get(_target) : _suffix;
      String child = _stemname + "Context." + suffix;
      File destfile = new File(parent, child);
      log("Generated filename computed as "+destfile, Project.MSG_DEBUG);
      
      if (destfile.exists() && _smfile.lastModified() <= destfile.lastModified())
      {
         log("Generation omitted as " + destfile + " is up to date.", Project.MSG_VERBOSE);
         return;
      }
      if (!destfile.exists())
         log("Generating file " + destfile + "..");
      else
         log("Updating file " + destfile + "..");

      Java javaTask = (Java) getProject().createTask("java");
      javaTask.setTaskName(getTaskName());
      javaTask.setClasspath(_classpath);
      
      javaTask.setJar(_smcjar);
      
      javaTask.createArg().setValue("-"+_target);
      
      if (_destdir != null)
      {
         javaTask.createArg().setValue("-d");
         javaTask.createArg().setFile(_destdir);
      }
      
      if (_suffix != null)
      {
         javaTask.createArg().setValue("-suffix");
         javaTask.createArg().setValue(_suffix);
      }

      if (_reflect) { javaTask.createArg().setValue("-reflect"); }
      if (_sync) { javaTask.createArg().setValue("-sync"); }
      if (_serial) { javaTask.createArg().setValue("-serial"); }
      if (_g) { javaTask.createArg().setValue("-g"); }
      
      if (_glevel != null)
      {
         javaTask.createArg().setValue("-glevel");
         javaTask.createArg().setValue(_glevel);
      }
      
      javaTask.createArg().setFile(_smfile);
      
      javaTask.setFork(true);

      if (javaTask.executeJava() != 0)
         throw new BuildException("error");
      
   }
   
   private void validateParameters()
   {
      if (_target == null)
      {
         throw new BuildException("target attribute is required");
      }
      if (_smfile == null)
      {
         throw new BuildException(".sm file atrribute is required");
      }
      if (_smcjar == null)
      {
         throw new BuildException("smcjar file atrribute is required");
      }
      if (_destdir != null && !_destdir.isDirectory())
      {
         throw new BuildException(_destdir + " is not a valid directory");
      }
      if (_glevel != null && 
            !"0".equals(_glevel) && !"1".equals(_glevel) && !"2".equals(_glevel) )
      {
         throw new BuildException("Invalid value for glevel, should be 0, 1 or 2");
      }
   }
   
}
