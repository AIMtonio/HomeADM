package operacionesPDA.beanWS.response;

import java.util.ArrayList;

import soporte.bean.UsuarioBean;
import general.bean.BaseBeanWS;

public class SP_SMSAP_Usuarios_DescargaResponse extends BaseBeanWS{
	private ArrayList<UsuarioBean> usuarios = new ArrayList<UsuarioBean>();

		
	public void addUsuario(UsuarioBean usuario){  
        this.usuarios.add(usuario);  
	}
	public ArrayList<UsuarioBean> getUsuarios() {
		return usuarios;
	}
	public void setUsuarios(ArrayList<UsuarioBean> usuarios) {
		this.usuarios = usuarios;
	}
	
}