package cobranza.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
import cobranza.bean.BitacoraSegCobBean;
import cobranza.bean.RepBitacoraSegCobBean;
import cobranza.dao.BitacoraSegCobDAO;

public class BitacoraSegCobServicio extends BaseServicio{
	BitacoraSegCobDAO bitacoraSegCobDAO = null;
	
	public static interface Enum_Trans_BitSegCob{
		int alta = 1;
	}
	public static interface Enum_Lis_BitSegCob{
		int reporteExcel = 1;
		int promesaSegCob = 2;
	}
	
	//alta de la bitacora de seguimiento de cobranza
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,BitacoraSegCobBean bitacoraSegCobBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaGrid(bitacoraSegCobBean);
		switch(tipoTransaccion){
			case Enum_Trans_BitSegCob.alta:
				mensaje = bitacoraSegCobDAO.grabaBitacoraSegCob(bitacoraSegCobBean, listaBean);
				break;
		}
		return mensaje;
	}
	
	//lista de parametros del grid
		public List listaGrid(BitacoraSegCobBean lisBitacoraSegCob){

			List<String> numPromesaLis	  = lisBitacoraSegCob.getLisNumPromesa();
			List<String> fechaPromPagoLis = lisBitacoraSegCob.getLisFechaPromPago();
			List<String> montoPromPagoLis = lisBitacoraSegCob.getLisMontoPromPago();
			List<String> comentarioPromLis = lisBitacoraSegCob.getLisComentarioProm();
			
			ArrayList listaDetalle = new ArrayList();
			BitacoraSegCobBean bitSegCobBean = null;
			if(numPromesaLis !=null){ 			
				try{	
				int tamanio = numPromesaLis.size();
					for(int i=0; i<tamanio; i++){
					
						bitSegCobBean = new BitacoraSegCobBean();
						
						bitSegCobBean.setNumPromesa(numPromesaLis.get(i));
						bitSegCobBean.setFechaPromPago(fechaPromPagoLis.get(i));
						bitSegCobBean.setMontoPromPago(montoPromPagoLis.get(i));
						bitSegCobBean.setComentarioProm(comentarioPromLis.get(i));
						
						listaDetalle.add(i,bitSegCobBean);	
					}

				}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid de tipos de acciones", e);	
			}
		}
		return listaDetalle;
		}
	
	// Creacion del reporte en PDf de la bitacora de seguimiento de cobranza
	public ByteArrayOutputStream reporteBitSegCobPDF(RepBitacoraSegCobBean bitSegCobBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaIniReg",(!bitSegCobBean.getFechaIniReg().isEmpty() ? bitSegCobBean.getFechaIniReg() : Constantes.FECHA_VACIA));
		parametrosReporte.agregaParametro("Par_CreditoID", (!bitSegCobBean.getCreditoID().isEmpty() ? bitSegCobBean.getCreditoID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_FechaFinReg", (!bitSegCobBean.getFechaFinReg().isEmpty() ? bitSegCobBean.getFechaFinReg() : Constantes.FECHA_VACIA));
		parametrosReporte.agregaParametro("Par_UsuarioReg", (!bitSegCobBean.getUsuarioReg().isEmpty() ? bitSegCobBean.getUsuarioReg() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_AccionID", (!bitSegCobBean.getAccionID().isEmpty() ? bitSegCobBean.getAccionID() : Constantes.STRING_CERO));
		
		parametrosReporte.agregaParametro("Par_FechaIniProm", (!bitSegCobBean.getFechaIniProm().isEmpty() ? bitSegCobBean.getFechaIniProm() : Constantes.FECHA_VACIA));
		parametrosReporte.agregaParametro("Par_RespuestaID", (!bitSegCobBean.getRespuestaID().isEmpty() ? bitSegCobBean.getRespuestaID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_FechaFinProm", (!bitSegCobBean.getFechaFinProm().isEmpty() ? bitSegCobBean.getFechaFinProm() : Constantes.FECHA_VACIA));
		parametrosReporte.agregaParametro("Par_ClienteID", (!bitSegCobBean.getClienteID().isEmpty() ? bitSegCobBean.getClienteID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_LimiteRenglones", (!bitSegCobBean.getLimiteReglones().isEmpty() ? bitSegCobBean.getLimiteReglones() : Constantes.STRING_CERO));		

		parametrosReporte.agregaParametro("Par_NombreInstitucion", bitSegCobBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSis", bitSegCobBean.getFechaSis());
		parametrosReporte.agregaParametro("Par_claveUsuario",bitSegCobBean.getClaveUsuario());
		
		parametrosReporte.agregaParametro("Par_DescAccion",bitSegCobBean.getDescAccion());
		parametrosReporte.agregaParametro("Par_DescRespuesta",bitSegCobBean.getDescRespuesta());
		parametrosReporte.agregaParametro("Par_DescUsuReg",bitSegCobBean.getDesUsuRec());

		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	//reporte en excel de la bitacora de seguimiento de cobranza
	public List listaBitacoraSegCob(int tipoLista,RepBitacoraSegCobBean bitacoraSegCobBean){		
		List listaBitacora = null;
		switch(tipoLista){
		case Enum_Lis_BitSegCob.reporteExcel:
			listaBitacora = bitacoraSegCobDAO.reporteBitacoraSegCob(tipoLista,bitacoraSegCobBean);
			break;
		}

		return listaBitacora;
	}
	
	//Lista para grid promesas en la pantalla biacora seguimiento de cobranza
	public List listaPromesaSegCob(int tipoLista,BitacoraSegCobBean bitacoraSegCobBean){		
		List listaPromesas = null;
		switch(tipoLista){
		case Enum_Lis_BitSegCob.promesaSegCob:
			listaPromesas = bitacoraSegCobDAO.promesasSegCob(tipoLista,bitacoraSegCobBean);
			break;
		}

		return listaPromesas;
	}

	public BitacoraSegCobDAO getBitacoraSegCobDAO() {
		return bitacoraSegCobDAO;
	}

	public void setBitacoraSegCobDAO(BitacoraSegCobDAO bitacoraSegCobDAO) {
		this.bitacoraSegCobDAO = bitacoraSegCobDAO;
	}	
}
