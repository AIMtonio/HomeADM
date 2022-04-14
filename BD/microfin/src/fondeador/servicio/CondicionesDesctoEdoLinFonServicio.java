package fondeador.servicio;

import fondeador.bean.CondicionesDesctoEdoLinFonBean;
import fondeador.dao.CondicionesDesctoEdoLinFonDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
 
public class CondicionesDesctoEdoLinFonServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CondicionesDesctoEdoLinFonDAO condicionesDesctoEdoLinFonDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_LineaFon {
		int principal = 1;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_LineaFon {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_LineaFon {
		int alta = 1;
	}
	
	public CondicionesDesctoEdoLinFonServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CondicionesDesctoEdoLinFonBean condicionesDesctoEdoLinFonBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_LineaFon.alta:		
				mensaje = alta(condicionesDesctoEdoLinFonBean);				
				break;					
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean alta(CondicionesDesctoEdoLinFonBean condicionesDesctoEdoLinFonBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaEstados = (ArrayList) listaGridEstados(condicionesDesctoEdoLinFonBean);
		mensaje = condicionesDesctoEdoLinFonDAO.altaEstados(condicionesDesctoEdoLinFonBean, listaEstados);		
		return mensaje;
	}
	
	public List listaGridEstados(CondicionesDesctoEdoLinFonBean condicionesDesctoEdoLinFonBean){
		List<String> listaEstadoID   = condicionesDesctoEdoLinFonBean.getListaEstadoID(); 
		List<String> listaMunicipioID   = condicionesDesctoEdoLinFonBean.getListaMunicipioID();
		List<String> listaLocalidadID   = condicionesDesctoEdoLinFonBean.getListaLocalidadID();

		ArrayList listaDetalle = new ArrayList();
		
		CondicionesDesctoEdoLinFonBean condicionesDesctoFonBean = null;
		try{
			if(!listaEstadoID.isEmpty()){ 
				int tamanio = listaEstadoID.size();
			
				for(int i=0; i<tamanio; i++){
					condicionesDesctoFonBean = new CondicionesDesctoEdoLinFonBean();
					condicionesDesctoFonBean.setEstadoID(listaEstadoID.get(i));
					condicionesDesctoFonBean.setMunicipioID(listaMunicipioID.get(i));
					condicionesDesctoFonBean.setLocalidadID(listaLocalidadID.get(i));
					condicionesDesctoFonBean.setLineaFondeoIDEdo(condicionesDesctoEdoLinFonBean.getLineaFondeoIDEdo());
					condicionesDesctoFonBean.setNumHabitantesInf(condicionesDesctoEdoLinFonBean.getNumHabitantesInf());
					condicionesDesctoFonBean.setNumHabitantesSup(condicionesDesctoEdoLinFonBean.getNumHabitantesSup());
					listaDetalle.add(condicionesDesctoFonBean);
				}
			}else{
				throw new Exception("Error en lista de grid de condiciones de descuento. Estados.");
			}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de grid de condiciones de descuento. Estados.", e);
		}
		return listaDetalle;
	}
	
	public List lista(int tipoLista, CondicionesDesctoEdoLinFonBean condicionesDesctoEdoLinFonBean){		
		List listaLineasFond = null;
		switch (tipoLista) {
			case Enum_Lis_LineaFon.principal:		
				listaLineasFond = condicionesDesctoEdoLinFonDAO.listaPrincipal(condicionesDesctoEdoLinFonBean, tipoLista);				
				break;				
		}		
		return listaLineasFond;
	}

	
	//------------------ Geters y Seters ------------------------------------------------------

	public CondicionesDesctoEdoLinFonDAO getCondicionesDesctoEdoLinFonDAO() {
		return condicionesDesctoEdoLinFonDAO;
	}

	public void setCondicionesDesctoEdoLinFonDAO(
			CondicionesDesctoEdoLinFonDAO condicionesDesctoEdoLinFonDAO) {
		this.condicionesDesctoEdoLinFonDAO = condicionesDesctoEdoLinFonDAO;
	}
		
	
}

