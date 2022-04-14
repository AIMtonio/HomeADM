package credito.servicio;

import general.bean.MensajeTransaccionArchivoBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.ClienteArchivosBean;
import soporte.servicio.FileUploadServicio.Enum_Con_File;

import credito.bean.CreditosArchivoBean;
import credito.dao.CreditoArchivoDAO;

public class CreditoArchivoServicio extends BaseServicio{

	//---------- Variables ------------------------------------------------------------------------
	CreditoArchivoDAO creditoArchivoDAO = null;

	public static interface Enum_Tra_ArchivoCredito {
		int altaCred		= 1; //Alta de archivos créditos
		
	}
	public static interface Enum_Con_ArchivoCredito {
		int principalCred   = 1; //consulta principal de archivos de crédito
	}
	public static interface Enum_Lis_ArchivoCredito{
		int principalCredLis    = 1; //Lista principal de archivos de crédito
		int LisPorTipoDoc       = 2; //Lista de archivos de crédito por tipo de documento
	}
	public static interface Enum_Tra_ArchivoCreditoConsulta{
		int ConsulCantDoc    = 1; //Consulta Cantidad de archivos de crédito
		
	}
	public static interface Enum_Tra_ArchivoCreditoBaja{
		int bajaPorFolio    = 1; //baja principal de archivos de crédito
		
	}
	
	/* Graba transaccion para Archivos o Documentos de los Creditos */
	
	public MensajeTransaccionArchivoBean grabaTransaccionCredito(int tipoTransaccion,
																 CreditosArchivoBean creditosArchivoBean) {
		MensajeTransaccionArchivoBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_ArchivoCredito.altaCred:
			mensaje = altaArchivosCredito(creditosArchivoBean);
			break;	
		
		}
		return mensaje;
	}
	
	public MensajeTransaccionArchivoBean altaArchivosCredito(CreditosArchivoBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = creditoArchivoDAO.altaArchivosCredito(file);		
		return mensaje;
	}
	
	
	/* transaccion para Baja de Archivos o Documentos de los creditos*/
	public MensajeTransaccionArchivoBean bajaArchivoCredito(int tipoBaja,CreditosArchivoBean creditosArchivoBean) {
		
			MensajeTransaccionArchivoBean mensaje = null;
			switch (tipoBaja) {
				case Enum_Tra_ArchivoCreditoBaja.bajaPorFolio:
						mensaje = bajaArchivosCreditoPorFolio(creditosArchivoBean, tipoBaja);
						
						break;	

			}
			return mensaje;
	}

	public MensajeTransaccionArchivoBean bajaArchivosCreditoPorFolio(CreditosArchivoBean file, int tipoBaja){
			MensajeTransaccionArchivoBean mensaje = null;
			mensaje = creditoArchivoDAO.procBajaArchivosCredito(file, tipoBaja);		
			return mensaje;
	}

	/*Lista de archivos de Credito principal*/
	public List listaArchivosCredito(int tipoLista, CreditosArchivoBean creditosArchivoBean){		
		List listaArchCred = null;
		switch (tipoLista) {
			case Enum_Lis_ArchivoCredito.principalCredLis:		
				listaArchCred = creditoArchivoDAO.listaArchivosCredito(creditosArchivoBean, tipoLista);				
				break;	
			case Enum_Lis_ArchivoCredito.LisPorTipoDoc:		
				listaArchCred = creditoArchivoDAO.listaArchivosCreditoTipoDoc(creditosArchivoBean, tipoLista);				
				break;
		}		
		return listaArchCred;
	}
	
	//Consulta de archivos de credito
	public CreditosArchivoBean consulta(int tipoConsulta, CreditosArchivoBean creditosArchivoBean){
		CreditosArchivoBean archivo = null;
		switch (tipoConsulta) {
			case Enum_Tra_ArchivoCreditoConsulta.ConsulCantDoc:		
				archivo = creditoArchivoDAO.consultaCantDocumentos(creditosArchivoBean, tipoConsulta);	
				break;	
		
			
		}
				
		return archivo;
	}
	//Reporte de Archivos de credito PDF
	public ByteArrayOutputStream reporteArchivosCreditoPDF(CreditosArchivoBean creditosArchivoBean , String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_CreditoID",creditosArchivoBean.getCreditoID());
		parametrosReporte.agregaParametro("Par_TipoDocumentoID",creditosArchivoBean.getTipoDocumentoID());
		parametrosReporte.agregaParametro("Par_ClienteID",creditosArchivoBean.getClienteID());
		parametrosReporte.agregaParametro("Par_Estatus",creditosArchivoBean.getEstatus());
		parametrosReporte.agregaParametro("Par_NombreCliente",creditosArchivoBean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_GrupoID",creditosArchivoBean.getGrupoID());
		parametrosReporte.agregaParametro("Par_NombreGrupo",creditosArchivoBean.getNombreGrupo());
		parametrosReporte.agregaParametro("Par_Ciclo",creditosArchivoBean.getCiclo());
		parametrosReporte.agregaParametro("Par_CuentaID",creditosArchivoBean.getCuentaID());
		parametrosReporte.agregaParametro("Par_DescripcionCta",creditosArchivoBean.getDescripcionCta());
		parametrosReporte.agregaParametro("Par_ProductoCredID",creditosArchivoBean.getProductoCreditoID());
		parametrosReporte.agregaParametro("Par_NombreProdCred",creditosArchivoBean.getNombreProducto());
		parametrosReporte.agregaParametro("Par_Usuario",creditosArchivoBean.getNombreusuario());//isEmpty();//?creditosArchivoBean.getNombreusuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NombreInstitucion",creditosArchivoBean.getNombreInstitucion());//isEmpty())?creditosArchivoBean.getNombreInstitucion(): "TODOS");
		parametrosReporte.agregaParametro("Par_fecha",creditosArchivoBean.getParFechaEmision());
	
	
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	//------------------ Geters y Seters ------------------------------------------------------
	
	public void setCreditoArchivoDAO(CreditoArchivoDAO creditoArchivoDAO) {
		this.creditoArchivoDAO = creditoArchivoDAO;
	}

	public CreditoArchivoDAO getCreditoArchivoDAO() {
		return creditoArchivoDAO;
	}	
	
	
}
