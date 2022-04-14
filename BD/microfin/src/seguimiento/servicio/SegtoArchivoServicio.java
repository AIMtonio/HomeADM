package seguimiento.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
import seguimiento.bean.SegtoArchivoBean;
import seguimiento.dao.SegtoArchivoDAO;

public class SegtoArchivoServicio extends BaseServicio{
	
	SegtoArchivoDAO segtoArchivoDAO = null;
	public SegtoArchivoServicio(){
		super();
	}
	
	public static interface Enum_Lis_Archivos {
		int principal	= 1;
		int archivos	= 2;
	}

	public MensajeTransaccionBean altaArchivos( final SegtoArchivoBean segtoArchivoBean,final List listaArchAdjuntos){
		MensajeTransaccionBean mensaje = null;
		mensaje = segtoArchivoDAO.grabaListaAclaraArch(segtoArchivoBean, listaArchAdjuntos);
		return mensaje;
	}

	public List listaSegtoArchivos(int tipoLista, SegtoArchivoBean segtoArchivoBean){		
		List listaAclaraArchivos = null;
		switch (tipoLista) {
			case Enum_Lis_Archivos.archivos:		
				listaAclaraArchivos = segtoArchivoDAO.listaSegtoArchivos(segtoArchivoBean, Enum_Lis_Archivos.archivos);	
				break;
		}			
		return listaAclaraArchivos;
	}

	//Reporte de Archivos de Seguimiento PDF
	public ByteArrayOutputStream reporteArchivosSegtoPDF(SegtoArchivoBean segtoArchivo, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_SegtoPrograID", segtoArchivo.getSegtoPrograID());
		parametrosReporte.agregaParametro("Par_NumSecuencia", segtoArchivo.getNumSecuencia());
		parametrosReporte.agregaParametro("Par_FechaEmision",segtoArchivo.getFecha());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!segtoArchivo.getNombreUsuario().isEmpty())?segtoArchivo.getNombreUsuario(): "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!segtoArchivo.getNombreInstitucion().isEmpty())?segtoArchivo.getNombreInstitucion(): "TODOS");

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public SegtoArchivoDAO getSegtoArchivoDAO() {
		return segtoArchivoDAO;
	}

	public void setSegtoArchivoDAO(SegtoArchivoDAO segtoArchivoDAO) {
		this.segtoArchivoDAO = segtoArchivoDAO;
	}
}