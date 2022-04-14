package originacion.servicio;

import java.util.ArrayList;
import java.util.List;

import originacion.bean.DiasPasoVencidoBean;
import originacion.dao.DiasPasoVencidoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class DiasPasoVencidoServicio extends BaseServicio{	
	DiasPasoVencidoDAO diasPasoVencidoDAO=null;

	public DiasPasoVencidoServicio() {
		super();
	}
	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Tra_DiasPasoVencido {
		int alta = 1;
	}
	public static interface Enum_Lis_DiasPasoVencido {
		int listaPorProducto = 1;
	}
	public static interface Enum_Baj_DiasPasoVencido {
		int bajaPorProducto = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	DiasPasoVencidoBean diasPasoVencidoBean ){
		ArrayList listaDiasPasoVencido = (ArrayList) creaListaDetalle(diasPasoVencidoBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_DiasPasoVencido.alta:		
				mensaje = diasPasoVencidoDAO.grabaDiasAtraso(diasPasoVencidoBean,listaDiasPasoVencido, Enum_Baj_DiasPasoVencido.bajaPorProducto);									
				break;			
		}
		return mensaje;
	}
	public List lista(int tipoLista, DiasPasoVencidoBean diasPasoVencidoBean){		
		List diasPasoVencido = null;
		switch (tipoLista) {	
			case Enum_Lis_DiasPasoVencido.listaPorProducto:		
				diasPasoVencido = diasPasoVencidoDAO.listaDiasPVenProducto(diasPasoVencidoBean, tipoLista);			
				break;			 
		}				
		return diasPasoVencido;
	}
	
	public List creaListaDetalle(DiasPasoVencidoBean diasPasoVencidoBean) {
			
		List<String> frecuencia  = diasPasoVencidoBean.getLfrecuencia();
		List<String> diasPasoVencido = diasPasoVencidoBean.getLdiasPasoVencido();		

		ArrayList listaDetalle = new ArrayList();
		DiasPasoVencidoBean diasPasoVen = null;	
		if(diasPasoVencido != null){
			int tamanio = diasPasoVencido.size();			
			for (int i = 0; i < tamanio; i++) {
				diasPasoVen = new DiasPasoVencidoBean();
				diasPasoVen.setFrecuencia(frecuencia.get(i));
				diasPasoVen.setDiasPasoVencido(diasPasoVencido.get(i));		
				listaDetalle.add(diasPasoVen);
			}
		}
		return listaDetalle;
		
	}
	
	//------------getter y setter--------------
	public DiasPasoVencidoDAO getDiasPasoVencidoDAO() {
		return diasPasoVencidoDAO;
	}
	public void setDiasPasoVencidoDAO(DiasPasoVencidoDAO diasPasoVencidoDAO) {
		this.diasPasoVencidoDAO = diasPasoVencidoDAO;
	}
	
}
