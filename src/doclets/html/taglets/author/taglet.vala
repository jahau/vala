/*
 * Valadoc - a documentation tool for vala.
 * Copyright (C) 2008 Florian Brosch
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

using Valadoc;
using GLib;
using Vala;
using Gee;


public class AuthorHtmlTaglet : MainTaglet {
	private string? email;
	private string name;

	public override int order {
		get { return 400; }
	}

	public override bool write_block_start ( void* res ) {
		((GLib.FileStream)res).puts ( "\t\t<table width=\"100%\" align=\"center\">\n" );
		((GLib.FileStream)res).puts ( "\t\t\t<tr>\n" );
		((GLib.FileStream)res).puts ( "\t\t\t\t<td colspan=\"2\"><h5>Version:</h5></td>\n" );
		((GLib.FileStream)res).puts ( "\t\t\t</tr>\n" );
		((GLib.FileStream)res).puts ( "\t\t\t<tr>" );
		((GLib.FileStream)res).puts ( "\t\t\t\t<td width=\"5\">&nbsp;</td>\n" );
		((GLib.FileStream)res).puts ( "\t\t\t\t<td>\n" );
		return true;
	}

	public override bool write_block_end ( void* res ) {
		((GLib.FileStream)res).puts ( "</td>\n" );
		((GLib.FileStream)res).puts ( "\t\t\t</tr>" );
		((GLib.FileStream)res).puts ( "\t\t</table>\n" );
		return true;
	}

	public override bool parse ( Valadoc.Settings settings, Valadoc.Tree tree, Valadoc.Reporter reporter, string line_start, int line, int pos, Valadoc.Basic me, Gee.ArrayList<Taglet> content ) {
		if ( content.size != 1 ) {
			return false;
		}

		Taglet tag = content.get ( 0 );
		if ( tag is StringTaglet == false ) {
			return false;
		}

		string str = ((StringTaglet)tag).content;
		str = str.strip ( );
		return true;
	}

	public override bool write ( void* res, int max, int index ) {
		((GLib.FileStream)res).printf ( "%s", this.version );
		if ( max != index+1 )
			((GLib.FileStream)res).puts ( ", " );

		return true;
	}
}



[ModuleInit]
public GLib.Type register_plugin ( Gee.HashMap<string, Type> taglets ) {
        GLib.Type type = typeof ( AuthorHtmlTaglet );
		taglets.set ( "author", type );
		return type;
}

