package fondeador.servicio;

import fondeador.bean.CondicionesDesctoActLinFonBean;
import fondeador.dao.CondicionesDesctoActLinFonDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
 
public class CondicionesDesctoActLinFonServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CondicionesDesctoActLinFonDAO condicionesDesctoActLinFonDAO = null;			   

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
		int modificacion = 2;
	}
	
	public CondicionesDesctoActLinFonServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CondicionesDesctoActLinFonBean condicionesDesctoActLinFonBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_LineaFon.alta:		
				mensaje = alta(condicionesDesctoActLinFonBean);				
				break;					
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean alta(CondicionesDesctoActLinFonBean condicionesDesctoActLinFonBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaActividades = (ArrayList) listaGridActividades(condicionesDesctoActLinFonBean);
		mensaje = condicionesDesctoActLinFonDAO.altaActividades(condicionesDesctoActLinFonBean, listaActividades);		
		return mensaje;
	}
	
	public List listaGridActividades(CondicionesDesctoActLinFonBean condicionesDesctoActLinFonBean){
		List<String> listaActividadBMXID   = condicionesDesctoActLinFonBean.getListaActividadBMXID(); 

		ArrayList listaDetalle = new ArrayList();
		CondicionesDesctoActLinFonBean condicionesDesctoFonBean = null;
		try{
			if(!listaActividadBMXID.isEmpty()){ 
				int tamanio = listaActividadBMXID.size();
			
				for(int i=0; i<tamanio; i++){
					condicionesDesctoFonBean = new CondicionesDesctoActLinFonBean();
					condicionesDesctoFonBean.setActividadBMXID(listaActividadBMXID.get(i));
					condicionesDesctoFonBean.setLineaFondeoIDAct(condicionesDesctoActLinFonBean.getLineaFondeoIDAct());
					listaDetalle.add(condicionesDesctoFonBean);
				}
			}else{
				throw new Exception("Error en lista de grid de condiciones de descuento. Actividades BMX");
			}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de grid de condiciones de descuento. Actividades BMX", e);
		}
		return listaDetalle;
	}
	
	public List lista(int tipoLista, CondicionesDesctoActLinFonBean condicionesDesctoActLinFonBean){		
		List listaLineasFond = null;
		switch (tipoLista) {
			case Enum_Lis_LineaFon.principal:		
				listaLineasFond = condicionesDesctoActLinFonDAO.listaPrincipal(condicionesDesctoActLinFonBean, tipoLista);				
				break;				
		}		
		return listaLineasFond;
	}

	//------------------ Geters y Seters ------------------------------------------------------
	public CondicionesDesctoActLinFonDAO getCondicionesDesctoActLinFonDAO() {
		return condicionesDesctoActLinFonDAO;
	}

	public void setCondicionesDesctoActLinFonDAO(
			CondicionesDesctoActLinFonDAO condicionesDesctoActLinFonDAO) {
		this.condicionesDesctoActLinFonDAO = condicionesDesctoActLinFonDAO;
	}
		
}

