package bancaEnLinea.servicio;

import bancaEnLinea.bean.BEUsuariosBean;
import bancaEnLinea.dao.BEUsuariosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class BEUsuariosServicio extends BaseServicio{
	
	BEUsuariosDAO  bEUsuariosDAO = null;

	/* declaracion de enums*/
	public static interface Enum_Tra_BEUsuarios{
		int alta = 1;
		int modifica=2;
		int cancela =3;
	}
	public static interface Enum_Con_BEUsuarios{
		int consultaCliente=1;
	}
	

	public BEUsuariosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, BEUsuariosBean bEUsuariosBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_BEUsuarios.alta:						
				mensaje = bEUsuariosDAO.altaBEUsuarios(bEUsuariosBean);								
			break;
			case Enum_Tra_BEUsuarios.modifica:						
				mensaje = bEUsuariosDAO.modificaBEUsuarios(bEUsuariosBean);								
			break;
			case Enum_Tra_BEUsuarios.cancela:						
				mensaje = bEUsuariosDAO.cancelaBEUsuarios(bEUsuariosBean);								
			break;
			
		}
		return mensaje;
	}
	
	public BEUsuariosBean consulta (int tipoConsulta, BEUsuariosBean usuario){
		BEUsuariosBean  usuarioBE = new BEUsuariosBean();
		switch (tipoConsulta) {
		case Enum_Con_BEUsuarios.consultaCliente:						
			usuarioBE = bEUsuariosDAO.consultaBEUsuarios(usuario);								
		break;
		}
		
	return usuarioBE;
		
	}
	
	
	

	/* declaracion de getter y setters */
	public BEUsuariosDAO getbEUsuariosDAO() {
		return bEUsuariosDAO;
	}

	public void setbEUsuariosDAO(BEUsuariosDAO bEUsuariosDAO) {
		this.bEUsuariosDAO = bEUsuariosDAO;
	}
	
	
}