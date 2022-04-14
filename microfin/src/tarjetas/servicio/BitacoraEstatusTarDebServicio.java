package tarjetas.servicio;


import java.io.ByteArrayOutputStream;
import java.util.List;
 

import reporte.ParametrosReporte;
import reporte.Reporte;
import tarjetas.bean.BitacoraEstatusTarDebBean;
import tarjetas.dao.BitacoraEstatusTarDebDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;



public class BitacoraEstatusTarDebServicio extends BaseServicio {
	
	BitacoraEstatusTarDebDAO bitacoraEstatusTarDebDAO = null;
	
	public BitacoraEstatusTarDebServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_lis_tarjetaDebito{
		int principal = 1;	
	}

	public List lista(int tipoLista, BitacoraEstatusTarDebBean bitacoraEstatusTarDebBean){	
			List listaTarjetaDebito = null;
			switch (tipoLista) {
			case Enum_lis_tarjetaDebito.principal:		
				listaTarjetaDebito = bitacoraEstatusTarDebDAO.ListaPrincipal(tipoLista, bitacoraEstatusTarDebBean);	
				break;	
				}			
			return listaTarjetaDebito;
	}
	
	
	public ByteArrayOutputStream creaReporteBitacoraEstatusTarDebPDF(BitacoraEstatusTarDebBean bitacoraEstatusTarDebBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_TarjetaDebID",bitacoraEstatusTarDebBean.getTarjetaID());
	
		parametrosReporte.agregaParametro("Par_FechaEmision",bitacoraEstatusTarDebBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!bitacoraEstatusTarDebBean.getNombreUsuario().isEmpty())?bitacoraEstatusTarDebBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!bitacoraEstatusTarDebBean.getNombreInstitucion().isEmpty())?bitacoraEstatusTarDebBean.getNombreInstitucion(): "Todos");
		 	 
		
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	//------------------setter y getter-----------
	public BitacoraEstatusTarDebDAO getBitacoraEstatusTarDebDAO() {
		return bitacoraEstatusTarDebDAO;
	}


	public void setBitacoraEstatusTarDebDAO(
			BitacoraEstatusTarDebDAO bitacoraEstatusTarDebDAO) {
		this.bitacoraEstatusTarDebDAO = bitacoraEstatusTarDebDAO;
	}
		
}
