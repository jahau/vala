/* valanamespace.vala
 *
 * Copyright (C) 2006  Jürg Billeter
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

namespace Vala {
	public class Namespace : CodeNode {
		public readonly string# name;
		public readonly SourceReference# source_reference;

		List<Class#># classes;
		List<Struct#># structs;
		List<Enum#># enums;
		List<Field#># fields;
		
		public static Namespace# @new (string name, SourceReference source) {
			return (new Namespace (name = name, source_reference = source));
		}
		
		public void add_class (Class cl) {
			classes.append (cl);
			cl.@namespace = this;
		}
		
		public void remove_class (Class cl) {
			classes.remove (cl);
			cl.@namespace = null;
		}
		
		public void add_struct (Struct st) {
			structs.append (st);
			st.@namespace = this;
		}
		
		public void remove_struct (Struct st) {
			structs.remove (st);
			st.@namespace = null;
		}
				
		public void add_enum (Enum en) {
			enums.append (en);
			en.@namespace = this;
		}

		public List<Class># get_classes () {
			return classes.copy ();
		}
		
		public void add_field (Field f) {
			fields.append (f);
		}
		
		public override void accept (CodeVisitor visitor) {
			visitor.visit_begin_namespace (this);

			foreach (Class cl in classes) {
				cl.accept (visitor);
			}

			foreach (Struct st in structs) {
				st.accept (visitor);
			}

			foreach (Enum en in enums) {
				en.accept (visitor);
			}

			visitor.visit_end_namespace (this);
		}
	}
}
