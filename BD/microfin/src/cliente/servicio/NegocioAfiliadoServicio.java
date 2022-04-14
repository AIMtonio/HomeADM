
package cliente.servicio;

import java.util.List;

import cliente.bean.NegocioAfiliadoBean;
import cliente.dao.NegocioAfiliadoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class NegocioAfiliadoServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	NegocioAfiliadoDAO negocioAfiliadoDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_NegocioAfiliado {
		int principal 		= 1;
		int promotor 		= 2;
		int con_Cte  		= 3;
		int principalWS		= 4;
		int promotorWS		= 5;
	}

	public static interface Enum_Lis_NegocioAfiliado {
		int principal 		= 1;
		int Foranea	=2;
	}
	
	public static interface Enum_Tra_NegocioAfiliado {
		int alta		 = 1;
		int modificacion = 2;
		int baja		 = 3;
	}

	public NegocioAfiliadoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, NegocioAfiliadoBean negocioAfiliadoBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_NegocioAfiliado.alta:		
				mensaje = altaNegocioAfiliado(negocioAfiliadoBean);				
				break;				
			case Enum_Tra_NegocioAfiliado.modificacion:
				mensaje = modificaNegocioAfiliado(negocioAfiliadoBean);				
				break;		
			case Enum_Tra_NegocioAfiliado.baja:
				mensaje = bajaNegocioAfiliado(negocioAfiliadoBean, tipoActualizacion);
				break;
		}
		return mensaje;
	}
	

	
	public MensajeTransaccionBean altaNegocioAfiliado(NegocioAfiliadoBean negocioAfiliadoBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = negocioAfiliadoDAO.altaNegocioAfiliado(negocioAfiliadoBean);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaNegocioAfiliado(NegocioAfiliadoBean negocioAfiliadoBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = negocioAfiliadoDAO.modificaNegocioAfiliado(negocioAfiliadoBean);		
		return mensaje;
	}
	
	public MensajeTransaccionBean bajaNegocioAfiliado(NegocioAfiliadoBean negocioAfiliadoBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = negocioAfiliadoDAO.bajaNegocioAfiliado(negocioAfiliadoBean,tipoActualizacion );		
		return mensaje;
	}
	
	public NegocioAfiliadoBean consulta(int tipoConsulta, NegocioAfiliadoBean negocioBean){
		NegocioAfiliadoBean negocio = null;
		switch (tipoConsulta) {
			case Enum_Con_NegocioAfiliado.promotor:
				negocio = negocioAfiliadoDAO.consultaPromotor(Enum_Con_NegocioAfiliado.promotor, negocioBean);
			break;
			case Enum_Con_NegocioAfiliado.promotorWS:
				negocio = negocioAfiliadoDAO.consultaPromotorWS(Enum_Con_NegocioAfiliado.promotor, negocioBean);
			break;
			case Enum_Con_NegocioAfiliado.principal:
				negocio = negocioAfiliadoDAO.consultaPrincipal(negocioBean,Enum_Con_NegocioAfiliado.principal);
			break;	
			case Enum_Con_NegocioAfiliado.principalWS:
				negocio = negocioAfiliadoDAO.consultaPrincipalWS(negocioBean,Enum_Con_NegocioAfiliado.principal);
			break;	
			case Enum_Con_NegocioAfiliado.con_Cte:
				negocio = negocioAfiliadoDAO.consultaCte(negocioBean,Enum_Con_NegocioAfiliado.con_Cte);
			break;
		}
		return negocio;
	}

	
	public List lista(int tipoLista, NegocioAfiliadoBean negocioAfiliadoBean){		
		List listaClientes = null;
		switch (tipoLista) {
			case Enum_Lis_NegocioAfiliado.principal:		
				listaClientes = negocioAfiliadoDAO.listaPrincipal(negocioAfiliadoBean, tipoLista);				
				break;
			case Enum_Lis_NegocioAfiliado.Foranea:		
				listaClientes = negocioAfiliadoDAO.listaForanea(negocioAfiliadoBean, tipoLista);				
				break;
		}
		return listaClientes;
	}
	
	//------------------------Getters y Setters-------------------------------------
	
	public NegocioAfiliadoDAO getNegocioAfiliadoDAO() {
		return negocioAfiliadoDAO;
	}

	public void setNegocioAfiliadoDAO(NegocioAfiliadoDAO negocioAfiliadoDAO) {
		this.negocioAfiliadoDAO = negocioAfiliadoDAO;
	}

}