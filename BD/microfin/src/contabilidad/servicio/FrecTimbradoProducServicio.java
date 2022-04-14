package contabilidad.servicio;

import java.util.ArrayList;
import java.util.List;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import contabilidad.dao.FrecTimbradoProducDAO;
import contabilidad.bean.FrecTimbradoProducBean;

public class FrecTimbradoProducServicio extends BaseServicio  {
	FrecTimbradoProducDAO frecTimbradoProducDAO;
	public static interface Enum_Trans_FreTimProduc{
		int modificar= 2;
	}
	public static interface Enum_Lis_FreTimProduc{
		int listaPrincipal = 1;
		int listaForanea = 2;
		int listaPorFrecuencia = 3;
	}
	
	public static interface Enum_Con_FreTimProduc{
		int listaPrincipal = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	FrecTimbradoProducBean frecTimbradoProducBean){
		ArrayList listaFrecProduc = (ArrayList) creaListaDetalle(frecTimbradoProducBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Trans_FreTimProduc.modificar:		
				mensaje = frecTimbradoProducDAO.grabaFrecuProduc(frecTimbradoProducBean,listaFrecProduc);
			break ;	
		}
		return mensaje;
		
		}
		
		public List lista(int tipoLista,FrecTimbradoProducBean frecTimbradoProducBean){	
			List frecTimbradoProduc = null;
			switch (tipoLista) {
			case Enum_Lis_FreTimProduc.listaPrincipal:		
				frecTimbradoProduc = frecTimbradoProducDAO.listaPrincipal(frecTimbradoProducBean, tipoLista);			
				break;	
				case Enum_Lis_FreTimProduc.listaForanea:		
					frecTimbradoProduc = frecTimbradoProducDAO.listaForanea(frecTimbradoProducBean, tipoLista);			
				break;
				case Enum_Lis_FreTimProduc.listaPorFrecuencia:		
					frecTimbradoProduc = frecTimbradoProducDAO.listaFrecTimbradoProduc(frecTimbradoProducBean, tipoLista);			
				break;

			}				
			return frecTimbradoProduc;
		}
// CONSULTA
		public FrecTimbradoProducBean consulta(int tipoConsulta, FrecTimbradoProducBean frecTimbradoProducBean){
			FrecTimbradoProducBean frecTimbradoProduc = null;
			
			switch (tipoConsulta) {
			case Enum_Con_FreTimProduc.listaPrincipal:		
				frecTimbradoProduc = frecTimbradoProducDAO.consultaPrincipal(frecTimbradoProducBean, tipoConsulta);			
				break;	
			}
						
			return frecTimbradoProduc;
		}
		
		public List creaListaDetalle(FrecTimbradoProducBean frecTimbradoProducBean) {
				List<String> product  = frecTimbradoProducBean.getLproducCreditoID();
		ArrayList listaDetalle = new ArrayList();
		FrecTimbradoProducBean frecuenProduc = null;	
			if(product != null){
				int tamanio = product.size();			
				for (int i = 0; i < tamanio; i++) {
					frecuenProduc = new FrecTimbradoProducBean();
					frecuenProduc.setFrecuenciaID(frecTimbradoProducBean.getFrecuenciaID());
					
					frecuenProduc.setProducCreditoID(product.get(i));
					listaDetalle.add(frecuenProduc);
				}
				
			}
		return listaDetalle;
			
		}


	public FrecTimbradoProducDAO getFrecTimbradoProducDAO() {
		return frecTimbradoProducDAO;
	}

	public void setFrecTimbradoProducDAO(FrecTimbradoProducDAO frecTimbradoProducDAO) {
		this.frecTimbradoProducDAO = frecTimbradoProducDAO;
	}
	
}
