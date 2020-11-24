import java.io.*;
import java.nio.file.*;
import java.nio.file.attribute.*;
import static java.nio.file.FileVisitResult.*;
import static java.nio.file.FileVisitOption.*;
import java.util.*;

/**
 * Sample code that finds files that
 * match the specified glob pattern.
 * For more information on what
 * constitutes a glob pattern, see
 * http://docs.oracle.com/javase/javatutorials/tutorial/essential/io/fileOps.html#glob
 *
 * The file or directories that match
 * the pattern are printed to
 * standard out.  The number of
 * matches is also printed.
 *
 * When executing this application,
 * you must put the glob pattern
 * in quotes, so the shell will not
 * expand any wild cards:
 *     java Find . -name "*.java"
 */

public class Find {

    /**
     * A {@code FileVisitor} that finds
     * all files that match the
     * specified pattern.
     */
    public static class Finder
        extends SimpleFileVisitor<Path> {

        private final PathMatcher matcher;
        private int numMatches = 0;
        private int failedOperations = 0;
        private int searchedFiles = 0;
        private int searchedDirectories = 0;

        Finder(String pattern) {
            matcher = FileSystems.getDefault()
                    .getPathMatcher("glob:" + pattern);
        }

        // Compares the glob pattern against
        // the file or directory name.
        void find(Path file) {
            Path name = file.getFileName();
            if (name != null && matcher.matches(name)) {
                numMatches++;
                System.out.println("MATCHED: "
                                   +file);
            }
        }

        // Prints the total number of
        // matches to standard out.
        void done() {
            System.out.println("\nFinished search."
                              +"\nSearched:"
                              +"\n  "
                              +searchedFiles
                              +" files"
                              +"\n  "
                              +searchedDirectories
                              +" directories"
                              +"\nMatched files: "
                              + numMatches);
            System.err.println("Failed: "
                + failedOperations+"\n");
        }

        // Invoke the pattern matching
        // method on each file.
        @Override
        public FileVisitResult visitFile(Path file,
                BasicFileAttributes attrs) {
            searchedFiles++;
            find(file);
            return CONTINUE;
        }

        // Invoke the pattern matching
        // method on each directory.
        @Override
        public FileVisitResult preVisitDirectory(Path dir,
                BasicFileAttributes attrs) {
            searchedDirectories++;
            find(dir);
            return CONTINUE;
        }

        @Override
        public FileVisitResult visitFileFailed(Path file,
                IOException exc) {
            failedOperations++;
            System.err.println("FAILED: "
                              +exc.getMessage());
            return CONTINUE;
        }
    }

    static void usage() {
        System.err.println("java Find <path>" +
            " -name \"<glob_pattern>\"");
        System.exit(-1);
    }

    public static void main(String[] args)
        throws IOException {

        if (args.length < 3 || !args[1].equals("-name"))
            usage();
        
        Path startingDir = Paths.get(args[0]);
        String pattern = args[2];
        
        System.out.println("\nStarting search."
                          +"\nSearch parameters:"
                          +"\n  Starting directory: "
                          +startingDir.toString()
                          +"\n  Search pattern: '"
                          +pattern
                          +"'\n");

        Finder finder = new Finder(pattern);
        Files.walkFileTree(startingDir, finder);
        finder.done();
    }
}

