package tarjetas.servicio;


import java.io.ByteArrayOutputStream;
import java.util.List;
 

import reporte.ParametrosReporte;
import reporte.Reporte;
import tarjetas.bean.BitacoraEstatusTarCredBean;
import tarjetas.dao.BitacoraEstatusTarCredDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;



public class BitacoraEstatusTarCredServicio extends BaseServicio {
	
	BitacoraEstatusTarCredDAO bitacoraEstatusTarCredDAO = null;
	
	public BitacoraEstatusTarCredServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_lis_tarjetaDebito{
		int principal = 1;	
	}

	public List lista(int tipoLista, BitacoraEstatusTarCredBean bitacoraEstatusTarCredBean){	
			List listaTarjetaDebito = null;
			switch (tipoLista) {
			case Enum_lis_tarjetaDebito.principal:		
				listaTarjetaDebito = bitacoraEstatusTarCredDAO.ListaPrincipal(tipoLista, bitacoraEstatusTarCredBean);	
				break;	
				}			
			return listaTarjetaDebito;
	}
	
	
	public ByteArrayOutputStream creaReporteBitacoraEstatusTarDebPDF(BitacoraEstatusTarCredBean bitacoraEstatusTarCredBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_TarjetaCredID",bitacoraEstatusTarCredBean.getTarjetaID());
	
		parametrosReporte.agregaParametro("Par_FechaEmision",bitacoraEstatusTarCredBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!bitacoraEstatusTarCredBean.getNombreUsuario().isEmpty())?bitacoraEstatusTarCredBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!bitacoraEstatusTarCredBean.getNombreInstitucion().isEmpty())?bitacoraEstatusTarCredBean.getNombreInstitucion(): "Todos");
		 	 
		
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}




	//------------------setter y getter-----------
	public BitacoraEstatusTarCredDAO getBitacoraEstatusTarCredDAO() {
		return bitacoraEstatusTarCredDAO;
	}


	public void setBitacoraEstatusTarCredDAO(
			BitacoraEstatusTarCredDAO bitacoraEstatusTarCredDAO) {
		this.bitacoraEstatusTarCredDAO = bitacoraEstatusTarCredDAO;
	}
		
}
