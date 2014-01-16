/**
 * A SLOC counter for the D language.
 * Author: Justin Whear
 *
 * This program employs a few simple regexes on a per-line basis to count the
 *  number of blank (whitespace only), comment, and code lines in a D file.
 *
 * Usage: dsloc <somefile.d
 *        dsloc a.d b.d c.d
 *        find . -name '*.d' | xargs dsloc
 *
 * Methodology: If a line is not blank, not a line comment, and not in a comment block,
 *   then it is a source line.
 *
 * The simple matching technique is not foolproof--it is possible to construct
 *   comment blocks which will fool the parser.  E.g. mixing /* and +/
 */
import std.stdio;
import std.regex;

enum reBlank = ctRegex!`^\s*$`;
enum reLineComment = ctRegex!`^\s*//`;
enum reBlockCommentStart = ctRegex!`^\s*(/\*|/\+)`;
enum reBlockCommentEnd = ctRegex!`\*/|\+/`;

void main(string[] args)
{
	ulong cBlank = 0,
		  cComment = 0,
		  cCode = 0,
		  cAll = 0;

	void countFile(File f)
	{
		bool inCommentBlock = false;
		foreach (line; f.byLine)
		{
			cAll++;
			if (inCommentBlock)
			{
				cComment++;
				inCommentBlock = !line.match(reBlockCommentEnd);
				continue;
			}

			if (line.match(reBlank))
				cBlank++;

			else if (line.match(reLineComment))
				cComment++;
			else if (line.match(reBlockCommentStart))
			{
				cComment++;

				if (!line.match(reBlockCommentEnd))
					inCommentBlock = true;
			}
			else
				cCode++;
		}
	}

	if (args.length > 1)
	{
		foreach (path; args[1..$])
			countFile(File(path, "r"));
	} else
		countFile(stdin);

	writefln("Total: %s, Blank: %s, Comment: %s, Code: %s", cAll, cBlank, cComment, cCode);
}
