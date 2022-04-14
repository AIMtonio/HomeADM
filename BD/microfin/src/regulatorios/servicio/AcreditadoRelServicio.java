package regulatorios.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import regulatorios.bean.AcreditadoRelBean;
import regulatorios.dao.AcreditadoRelDAO;

public class AcreditadoRelServicio extends BaseServicio {
	AcreditadoRelDAO acreditadoRelDAO = null;
	
	public static interface Enum_Trans_AcredRel{
		int alta = 1;
	}
	
	public static interface Enum_Lis_AcredRel{
		int listaGrid = 1;
	}
	
	public static interface Enum_Lis_ClavesRel{
		int listaCombo = 1;
	}
	
	// Graba transaccion
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AcreditadoRelBean acreditadoRelBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaGrid(acreditadoRelBean);
		switch(tipoTransaccion){
			case Enum_Trans_AcredRel.alta:
				mensaje = acreditadoRelDAO.grabaListaAcreditados(acreditadoRelBean,listaBean);
				break;
		}
		return mensaje;
	}
	
	//lista de parametros del grid
	public List listaGrid(AcreditadoRelBean lisAcreditadoRelBean){

		List<String> clienteIDLis	 	= lisAcreditadoRelBean.getLisClienteID();
		List<String> empleadoIDLis 		= lisAcreditadoRelBean.getLisEmpleadoID();
		List<String> claveRelacionIDLis = lisAcreditadoRelBean.getLisClaveRelacionID();
		
		ArrayList listaDetalle = new ArrayList();
		AcreditadoRelBean bean = null;
		if(claveRelacionIDLis !=null){ 			
			try{
				
			int tamanio = claveRelacionIDLis.size();
				for(int i=0; i<tamanio; i++){
				
					bean = new AcreditadoRelBean();

					bean.setClienteID(clienteIDLis.get(i));
					bean.setEmpleadoID(empleadoIDLis.get(i));
					bean.setClaveRelacionID(claveRelacionIDLis.get(i));
					
					listaDetalle.add(i,bean);	
				}

			}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid acreditados relacionados", e);	
		}
	}
	return listaDetalle;
	}
	
	//Lista para el grid 
	public List listaAcreditadosRelGrid(int tipoLista){
		List listaRegistros = null;
		
		switch(tipoLista){
			case Enum_Lis_AcredRel.listaGrid:
				listaRegistros = acreditadoRelDAO.listaGridAcreditados(tipoLista);
				break;
		}

		return listaRegistros;
	}
	
	// listas para comboBox de claves de relaciones
	public  Object[] listaComboClaves(int tipoLista) {
		List listaClaves = null;
			switch(tipoLista){
				case (Enum_Lis_ClavesRel.listaCombo): 
					listaClaves =  acreditadoRelDAO.listaComboClaves(tipoLista);
					break;
			}			
		return listaClaves.toArray(); 
	}

	public AcreditadoRelDAO getAcreditadoRelDAO() {
		return acreditadoRelDAO;
	}

	public void setAcreditadoRelDAO(AcreditadoRelDAO acreditadoRelDAO) {
		this.acreditadoRelDAO = acreditadoRelDAO;
	}
	
}
