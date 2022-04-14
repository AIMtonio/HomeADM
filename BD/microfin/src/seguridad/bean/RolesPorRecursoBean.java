package seguridad.bean;

import java.util.HashMap;

public class RolesPorRecursoBean {
	
	HashMap rolesPorRecursoMapa = new HashMap();
	String listaRoles;

	public HashMap getRolesPorRecursoMapa() {
		return rolesPorRecursoMapa;
	}

	public void setRolesPorRecursoMapa(HashMap rolesPorRecursoMapa) {
		this.rolesPorRecursoMapa = rolesPorRecursoMapa;
	}

	public String getListaRoles() {
		return listaRoles;
	}

	public void setListaRoles(String listaRoles) {
		this.listaRoles = listaRoles;
	}

}
