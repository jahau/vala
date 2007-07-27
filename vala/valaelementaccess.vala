/* valaelementaccess.vala
 *
 * Copyright (C) 2006-2007  Raffaele Sandrini, Jürg Billeter
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
 * 	Raffaele Sandrini <rasa@gmx.ch>
 * 	Jürg Billeter <j@bitron.ch>
 */

using GLib;
using Gee;

/**
 * Represents an array access expression e.g. "a[1,2]".
 */
public class Vala.ElementAccess : Expression {
	/**
	 * Expression representing the container on wich we want to access.
	 */
	public Expression! container { get; set; }
	
	/**
	 * Expressions representing the indices we want to access inside the container.
	 */
	private Gee.List<Expression>! indices = new ArrayList<Expression> ();
	
	public void append_index (Expression! index) {
		indices.add (index);
	}
	
	public Gee.List<Expression> get_indices () {
		return new ReadOnlyList<Expression> (indices);
	}
	
	public ElementAccess (construct Expression container, construct SourceReference source_reference) {
	}
	
	public override void accept (CodeVisitor! visitor) {
		container.accept (visitor);
		foreach (Expression e in indices) {
			e.accept (visitor);
		}

		visitor.visit_element_access (this);
	}
}
