package activos.servicio;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.xssf.usermodel.XSSFRow;

import activos.bean.CargaMasivaActivosBean;
import activos.dao.CargaArchivoMasivoActivoDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

public class CargaArchivoMasivoActivoServicio extends BaseServicio {

	CargaArchivoMasivoActivoDAO cargaArchivoMasivoActivoDAO = null;
	ParametrosSesionBean parametrosSesionBean = null;

	// Operaciones
	public static interface Enum_Tra_CargaActivos {
		int validacionArchivos 	= 1;
		int altaArchivo			= 2;
	}

	// Listas
	public static interface Enum_Lis_CargaActivos {
		int principal 	= 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CargaMasivaActivosBean cargaMasivaActivosBean) throws FileNotFoundException {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_CargaActivos.validacionArchivos:
				mensaje= cargaMasiva(cargaMasivaActivosBean, tipoTransaccion);
			break;
			case Enum_Tra_CargaActivos.altaArchivo:
				mensaje= cargaMasiva(cargaMasivaActivosBean, tipoTransaccion);
			break;
		}
		return mensaje;
	}

	public List<CargaMasivaActivosBean> lista (int tipoLista, CargaMasivaActivosBean cargaMasivaActivosBean) {

		List<CargaMasivaActivosBean> listaCargaMasivaActivosBean = null;
		try{
			switch(tipoLista){
				case Enum_Lis_CargaActivos.principal:
					listaCargaMasivaActivosBean = cargaArchivoMasivoActivoDAO.listaLayout(cargaMasivaActivosBean, tipoLista);
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Carga Masiva ", exception);
			exception.printStackTrace();
		}
		return listaCargaMasivaActivosBean;
	}

	//Inicio Carga Masiva
	public MensajeTransaccionBean cargaMasiva(CargaMasivaActivosBean cargaMasivaActivosBean, int tipoTransaccion) throws FileNotFoundException{
		MensajeTransaccionBean mensajeTransaccionBean = null;
		String nombreArchivo = "";
		try {

			mensajeTransaccionBean = new MensajeTransaccionBean();
			switch (tipoTransaccion) {
				// Inicio Validación de Layout
				case Enum_Tra_CargaActivos.validacionArchivos:
					String directorio = "";
					directorio = parametrosSesionBean.getRutaArchivos();
					directorio = directorio +"Activos/CargaMasiva/";
					nombreArchivo = Utileria.guardaArchivoExcel(directorio, cargaMasivaActivosBean.getFile());
					

					if(nombreArchivo.equals(Constantes.STRING_VACIO)){
						mensajeTransaccionBean.setNumero(990);
						mensajeTransaccionBean.setDescripcion("Ocurrio un Error en la lectura del Archivo de Carga Masiva de Activos.");
						mensajeTransaccionBean.setNombreControl("agregar");
					throw new Exception(mensajeTransaccionBean.getDescripcion());
					}
		
					//Lee el archivo en excel de pago de nomina
					ArrayList<XSSFRow> listaActivos = (ArrayList<XSSFRow>) Utileria.leerArchivoExcel(nombreArchivo, Constantes.leerExcel.cuerpo, Constantes.ENTERO_CERO );
		
				 	// Valido que la lista de facultados tenga un elemento
				 	if( listaActivos.size() == 0 || listaActivos.isEmpty() ) {
				 		mensajeTransaccionBean.setNumero(1);
				 		mensajeTransaccionBean.setDescripcion("El Archivo Carga Masiva de Activos esta Vacío.");
				 		mensajeTransaccionBean.setNombreControl("agregar");
						throw new Exception(mensajeTransaccionBean.getDescripcion());
				 	}
				 	
				 	mensajeTransaccionBean = cargaArchivoMasivoActivoDAO.procesoLayout(listaActivos, null, Enum_Tra_CargaActivos.validacionArchivos);
				 	mensajeTransaccionBean.setConsecutivoString(cargaMasivaActivosBean.getFile().getOriginalFilename());
				break;
				// Inicio Alta de Layout
				case Enum_Tra_CargaActivos.altaArchivo:
					List<CargaMasivaActivosBean> listaCargaMasivaActivosBean = lista(Enum_Lis_CargaActivos.principal, cargaMasivaActivosBean);

				 	// Valido que la lista de facultados tenga un elemento
				 	if( listaCargaMasivaActivosBean.size() == 0 || listaCargaMasivaActivosBean.isEmpty() ) {
				 		mensajeTransaccionBean.setNumero(1);
				 		mensajeTransaccionBean.setDescripcion("No Existen registros por procesar.");
				 		mensajeTransaccionBean.setNombreControl("procesar");
						throw new Exception(mensajeTransaccionBean.getDescripcion());
				 	}

				 	mensajeTransaccionBean = cargaArchivoMasivoActivoDAO.procesoLayout(null, listaCargaMasivaActivosBean, Enum_Tra_CargaActivos.altaArchivo);
				break;
			}
		} catch (Exception exception) {
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en Carga Masiva", exception);
			if(mensajeTransaccionBean ==  null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Error en Carga Masiva");
			}
			if (mensajeTransaccionBean.getNumero() == 0) {
				mensajeTransaccionBean.setNumero(999);
			}
		} finally {
			if( tipoTransaccion == Enum_Tra_CargaActivos.validacionArchivos ){
				Utileria.borraArchivo(nombreArchivo);
			}
		}

		return mensajeTransaccionBean;
	}//Fin Carga Masiva

	public CargaArchivoMasivoActivoDAO getCargaArchivoMasivoActivoDAO() {
		return cargaArchivoMasivoActivoDAO;
	}

	public void setCargaArchivoMasivoActivoDAO(
			CargaArchivoMasivoActivoDAO cargaArchivoMasivoActivoDAO) {
		this.cargaArchivoMasivoActivoDAO = cargaArchivoMasivoActivoDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


}
