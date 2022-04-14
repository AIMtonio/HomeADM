package fondeador.servicio;

import fondeador.bean.CondicionesDesctoDestLinFonBean;
import fondeador.dao.CondicionesDesctoDestLinFonDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

 
public class CondicionesDesctoDestLinFonServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CondicionesDesctoDestLinFonDAO condicionesDesctoDestLinFonDAO = null;			   

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
	
	public CondicionesDesctoDestLinFonServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CondicionesDesctoDestLinFonBean condicionesDesctoDestLinFonBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_LineaFon.alta:		
				mensaje = alta(condicionesDesctoDestLinFonBean);				
				break;					
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean alta(CondicionesDesctoDestLinFonBean condicionesDesctoDestLinFonBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaDestinos = (ArrayList) listaGridDestinos(condicionesDesctoDestLinFonBean);
		mensaje = condicionesDesctoDestLinFonDAO.altaDestinos(condicionesDesctoDestLinFonBean, listaDestinos);		
		return mensaje;
	}
	
	public List lista(int tipoLista, CondicionesDesctoDestLinFonBean condicionesDesctoDestLinFonBean){		
		List listaLineasFond = null;
		switch (tipoLista) {
			case Enum_Lis_LineaFon.principal:		
				listaLineasFond = condicionesDesctoDestLinFonDAO.listaPrincipal(condicionesDesctoDestLinFonBean, tipoLista);				
				break;				
		}		
		return listaLineasFond;
	}

	public List listaGridDestinos(CondicionesDesctoDestLinFonBean condicionesDesctoDestLinFonBean){
		List<String> listaDestinoCreID   = condicionesDesctoDestLinFonBean.getListaDestinoCreID();            

		ArrayList listaDetalle = new ArrayList();
		CondicionesDesctoDestLinFonBean condicionesDesctoFonBean = null;
		try{
			if(!listaDestinoCreID.isEmpty()){ 
				int tamanio = listaDestinoCreID.size();
			
				for(int i=0; i<tamanio; i++){
					condicionesDesctoFonBean = new CondicionesDesctoDestLinFonBean();
					condicionesDesctoFonBean.setDestinoCreID(listaDestinoCreID.get(i));
					condicionesDesctoFonBean.setLineaFondeoIDDest(condicionesDesctoDestLinFonBean.getLineaFondeoIDDest());
					listaDetalle.add(condicionesDesctoFonBean);
				}
			}else{
				throw new Exception("Error en lista de grid de condiciones de descuento. destinos");
			}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de grid de condiciones de descuento. destinos", e);
		}
		return listaDetalle;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------
	
	public CondicionesDesctoDestLinFonDAO getCondicionesDesctoDestLinFonDAO() {
		return condicionesDesctoDestLinFonDAO;
	}

	public void setCondicionesDesctoDestLinFonDAO(
			CondicionesDesctoDestLinFonDAO condicionesDesctoDestLinFonDAO) {
		this.condicionesDesctoDestLinFonDAO = condicionesDesctoDestLinFonDAO;
	}

}

