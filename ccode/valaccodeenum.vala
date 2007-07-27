/* valaccodeenum.vala
 *
 * Copyright (C) 2006-2007  Jürg Billeter
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Jürg Billeter <j@bitron.ch>
 */

using GLib;
using Gee;

/**
 * Represents an enum in the C code.
 */
public class Vala.CCodeEnum : CCodeNode {
	/**
	 * The name of this enum.
	 */
	public string name { get; set; }
	
	private Gee.List<string> values = new ArrayList<string> ();
	
	public CCodeEnum (construct string name = null) {
	}
	
	/**
	 * Adds the specified value to this enum.
	 *
	 * @param name  enum value name
	 * @param value optional numerical value
	 */
	public void add_value (string! name, string value = null) {
		if (value == null) {
			values.add (name);
		} else {
			values.add ("%s = %s".printf (name, value));
		}
	}
	
	public override void write (CCodeWriter! writer) {
		if (name != null) {
			writer.write_string ("typedef ");
		}
		writer.write_string ("enum ");
		writer.write_begin_block ();
		bool first = true;
		foreach (string value in values) {
			if (!first) {
				writer.write_string (",");
				writer.write_newline ();
			}
			writer.write_indent ();
			writer.write_string (value);
			first = false;
		}
		if (!first) {
			writer.write_newline ();
		}
		writer.write_end_block ();
		if (name != null) {
			writer.write_string (" ");
			writer.write_string (name);
		}
		writer.write_string (";");
		writer.write_newline ();
	}
}
