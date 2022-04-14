package soporte.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import soporte.bean.AsamGralUsuarioAutBean;
import soporte.bean.ParamApoyoEscolarBean;
import soporte.dao.AsamGralUsuarioAutDAO;
import soporte.servicio.ParamApoyoEscolarServicio.Enum_Con_ParamApoyoEsc;
import soporte.servicio.ParamApoyoEscolarServicio.Enum_Tra_ParamApoyoEsc;
import tarjetas.bean.GiroNegocioTarDebBean;
import tarjetas.servicio.GiroNegocioTarDebServicio.Enum_Con_GiroTarDeb;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
 
public class AsamGralUsuarioAutServicio  extends BaseServicio{

	public AsamGralUsuarioAutServicio() {
		super();
	}
	AsamGralUsuarioAutDAO asamGralUsuarioAutDAO = null;
	
	/* Transacciones para usuarios autorizados */
	public static interface Enum_Tra_UsuarioAut {
		int graba = 1;
		int alta = 2;
		int baja = 3;
	
	}
	/* Lista para el grid de Usuarios autorizados */
	public static interface Enum_Lis_Usuarios {
		int gridUsuarioAut = 1;

	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AsamGralUsuarioAutBean asamGralBean){
		ArrayList listaBean = (ArrayList) creaListaUsuarios(asamGralBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
		switch (tipoTransaccion) {
			case Enum_Tra_UsuarioAut.graba:
				mensaje = asamGralUsuarioAutDAO.grabaUsuariosAutorizados(asamGralBean,listaBean);
				break;
			case Enum_Tra_UsuarioAut.alta:		
				mensaje = asamGralUsuarioAutDAO.altaAsamGralUsuarioAut(asamGralBean);				
				break;				
			case Enum_Tra_UsuarioAut.baja:
				mensaje = asamGralUsuarioAutDAO.bajaAsamGralUsuarioAut(asamGralBean);				
				break;
				
			}
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error transaccion de usuarios autorizados", e);
			}
		return mensaje;
	}	
	
	
	/* Arma la lista de beans */
	public List creaListaUsuarios(AsamGralUsuarioAutBean bean) {		
		List<String> usuarioID = bean.getLusuarioID();
		List<String> nombreCompleto = bean.getLnombreCompleto();
		List<String> rolID = bean.getLrolID();
		ArrayList listaDetalle = new ArrayList();
		AsamGralUsuarioAutBean beanAux = null;	
		
		if(usuarioID != null){
			int tamanio = usuarioID.size();			
			for (int i = 0; i < tamanio; i++) {
				beanAux = new AsamGralUsuarioAutBean();
				beanAux.setUsuarioID(usuarioID.get(i));
				beanAux.setNombreCompleto(nombreCompleto.get(i));
				beanAux.setRolID(rolID.get(i));

				listaDetalle.add(beanAux);
			}
		}
		return listaDetalle;
	}

	
	//lista para el grid de usuarios autorizados				
	public List listaAsamGralUsuarioAut(int tipoLista, AsamGralUsuarioAutBean asamGralBean){		
		List listaUsuarios= null;
		switch (tipoLista) {
			case Enum_Lis_Usuarios.gridUsuarioAut:		
				listaUsuarios = asamGralUsuarioAutDAO.listaGridAsamGralUsuarioAut(asamGralBean, tipoLista);				
				break;	

		}		
		return listaUsuarios;
	}


	
	 /* ********************** GETTERS y SETTERS **************************** */

	public AsamGralUsuarioAutDAO getAsamGralUsuarioAutDAO() {
		return asamGralUsuarioAutDAO;
	}

	public void setAsamGralUsuarioAutDAO(AsamGralUsuarioAutDAO asamGralUsuarioAutDAO) {
		this.asamGralUsuarioAutDAO = asamGralUsuarioAutDAO;
	}
	

	
}
