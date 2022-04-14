package tarjetas.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import tarjetas.bean.TarDebArchAclaBean;
import tarjetas.dao.TarDebArchAclaDAO;
import tarjetas.servicio.TarDebAclaraServicio.Enum_Con_aclaracion;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;



public class TarDebArchAclaServicio extends BaseServicio {
	
	TarDebArchAclaDAO tarDebArchAclaDAO = null;
	
	public TarDebArchAclaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Tra_archivos {
		int altaArchivos 	= 1;
	}
	
	public static interface Enum_lis_archivos{
		int archivosCte 	 = 2;
	}

	public MensajeTransaccionBean altaArchivos( final TarDebArchAclaBean tarDebArchAclaBean,final List listaArchAdjuntos){		
		MensajeTransaccionBean mensaje = null;
		mensaje = tarDebArchAclaDAO.grabaListaAclaraArch(tarDebArchAclaBean, listaArchAdjuntos);
		return mensaje;
	}

	
	public List listaAclaraArchivos(int tipoLista, TarDebArchAclaBean tarDebArchAclaBean){		
		List listaAclaraArchivos = null;
		switch (tipoLista) {
			case Enum_lis_archivos.archivosCte:		
				listaAclaraArchivos = tarDebArchAclaDAO.listaAclaraArchivos(tarDebArchAclaBean, tipoLista);	
				break;
		}			
		return listaAclaraArchivos;
	}
	
	//Reporte de Archivos de Aclaraciones PDF
		public ByteArrayOutputStream reporteArchivosAclaracionesPDF(TarDebArchAclaBean tarDebArchAclaBean, String nombre, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_ReporteID", tarDebArchAclaBean.getReporteID());
			parametrosReporte.agregaParametro("Par_NombreCliente", nombre);
			parametrosReporte.agregaParametro("Par_FechaEmision",tarDebArchAclaBean.getFechaEmision());
			parametrosReporte.agregaParametro("Par_NomUsuario",(!tarDebArchAclaBean.getNombreUsuario().isEmpty())?tarDebArchAclaBean.getNombreUsuario(): "TODOS");
			parametrosReporte.agregaParametro("Par_NomInstitucion",(!tarDebArchAclaBean.getNombreInstitucion().isEmpty())?tarDebArchAclaBean.getNombreInstitucion(): "TODOS");

			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
	
	//------------------setter y getter-----------
	public TarDebArchAclaDAO getTarDebArchAclaDAO() {
		return tarDebArchAclaDAO;
	}
	public void setTarDebArchAclaDAO(TarDebArchAclaDAO tarDebArchAclaDAO) {
		this.tarDebArchAclaDAO = tarDebArchAclaDAO;
	}
}
