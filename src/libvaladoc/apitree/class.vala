/*
 * Valadoc.Api.- a documentation tool for vala.
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

using Gee;
using Valadoc.Content;

public class Valadoc.Api.Class : TypeSymbolNode, ClassHandler, StructHandler, SignalHandler, MethodHandler, EnumHandler, PropertyHandler, ConstructionMethodHandler, FieldHandler, DelegateHandler, ConstantHandler, TemplateParameterListHandler {
	private ArrayList<TypeReference> interfaces;
	private Vala.Class vclass;

	public Class (Vala.Class symbol, Node parent) {
		base (symbol, parent);
		this.interfaces = new ArrayList<TypeReference> ();

		this.vclass = symbol;

		if (glib_error == null) {
			if (this.full_name () == "GLib.Error") {
				glib_error = this;
			}
		}
	}

	protected TypeReference? base_type {
		private set;
		get;
	}

	public string? get_cname () {
		return this.vclass.get_cname();
	}

	public Collection<TypeReference> get_implemented_interface_list () {
		return this.interfaces;
	}

	internal bool is_vclass (Vala.Class vcl) {
		return this.vclass == vcl;
	}

	public bool is_abstract {
		get {
			return this.vclass.is_abstract;
		}
	}

	public void visit ( Doclet doclet ) {
		doclet.visit_class ( this );
	}

	public override NodeType node_type { get { return NodeType.CLASS; } }

	public override void accept (Doclet doclet) {
		visit (doclet);
	}

	private void set_parent_type_references (Tree root, Vala.Collection<Vala.DataType> lst) {
		if (this.interfaces.size != 0) {
			return;
		}

		foreach (Vala.DataType vtyperef in lst) {
			var inherited = new TypeReference (vtyperef, this);
			inherited.resolve_type_references (root);

			if (inherited.data_type is Class) {
				this.base_type = inherited;
			} else {
				this.interfaces.add (inherited);
			}
		}
	}

	protected override void resolve_type_references (Tree root) {
		var lst = this.vclass.get_base_types ();
		this.set_parent_type_references (root, lst);

		base.resolve_type_references (root);
	}

	protected override Inline build_signature () {
		var signature = new SignatureBuilder ();

		signature.append_keyword (get_accessibility_modifier ());
		if (is_abstract) {
			signature.append_keyword ("abstract");
		}
		signature.append_keyword ("class");
		signature.append_symbol (this);

		var type_parameters = get_children_by_type (NodeType.TYPE_PARAMETER, false);
		if (type_parameters.size > 0) {
			signature.append ("<", false);
			bool first = true;
			foreach (Item param in type_parameters) {
				if (!first) {
					signature.append (",", false);
				}
				signature.append_content (param.signature, false);
				first = false;
			}
			signature.append (">", false);
		}

		bool first = true;
		if (base_type != null) {
			signature.append (":");

			signature.append_content (base_type.signature);
			first = false;
		}

		if (interfaces.size > 0) {
			if (first) {
				signature.append (":");
			}

			foreach (Item implemented_interface in interfaces) {
				if (!first) {
					signature.append (",", false);
				}
				signature.append_content (implemented_interface.signature);
				first = false;
			}
		}

		return signature.get ();
	}
}
