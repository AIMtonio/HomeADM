package guardaValores.servicio;

import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import guardaValores.bean.ParamGuardaValoresBean;
import guardaValores.dao.ParamGuardaValoresDAO;

public class ParamGuardaValoresServicio extends BaseServicio {

	ParamGuardaValoresDAO paramGuardaValoresDAO = null;

	public static interface Enum_Tran_Parametros {
		int alta	 = 1;
		int modifica = 2;
	}

	public static interface Enum_Con_Parametros {
		int principal		 = 1;
		int foranea 		 = 2;
		int usuarioAdmon	 = 3;
	}

	public static interface Enum_Con_Facultados {
		int puestoFacultado	 = 1;
		int usuarioFacultado = 2;
	}

	public static interface Enum_Lis_Parametros {
		int listaPrincipal	= 1;
		int listaFacultados	= 2;
		int listaDocumentos	= 3;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParamGuardaValoresBean paramGuardaValoresBean) {

		MensajeTransaccionBean mensajeTransaccionBean = null;
		ArrayList listaFacultados = null;
		ArrayList listaDocumentos = null;
		
		try{
			switch (tipoTransaccion) {
				case Enum_Tran_Parametros.alta:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					listaFacultados = (ArrayList) crearListaFacultador(paramGuardaValoresBean);
					listaDocumentos = (ArrayList) crearListaDocumentos(paramGuardaValoresBean);
					mensajeTransaccionBean = paramGuardaValoresDAO.altaParametros(paramGuardaValoresBean, listaFacultados, listaDocumentos);
				break;
				case Enum_Tran_Parametros.modifica:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					listaFacultados = (ArrayList) crearListaFacultador(paramGuardaValoresBean);
					listaDocumentos = (ArrayList) crearListaDocumentos(paramGuardaValoresBean);
					mensajeTransaccionBean = paramGuardaValoresDAO.modificaParametros(paramGuardaValoresBean, listaFacultados, listaDocumentos);
				break;
				default:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean.setNumero(999);
					mensajeTransaccionBean.setDescripcion("Tipo de Transaccion desconocida.");
				break;
			}
		} catch(Exception exception){
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Ha ocurrido un Error al Grabar la Transaccion");
			}
			loggerSAFI.error(mensajeTransaccionBean.getDescripcion(), exception);
			exception.printStackTrace();
		}
		return mensajeTransaccionBean;
	}

	public ParamGuardaValoresBean consulta(int tipoConsulta, ParamGuardaValoresBean paramGuardaValoresBean) {

		ParamGuardaValoresBean parametros = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_Parametros.principal:
					parametros = paramGuardaValoresDAO.consultaPrincipal(paramGuardaValoresBean, tipoConsulta);
				break;
				case Enum_Con_Parametros.foranea:
					parametros = paramGuardaValoresDAO.validaParametros(paramGuardaValoresBean, tipoConsulta);
				break;
				case Enum_Con_Parametros.usuarioAdmon:
					parametros = paramGuardaValoresDAO.validaUsuarioAdmon(paramGuardaValoresBean, tipoConsulta);
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Parametros Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return parametros;
	}

	public ParamGuardaValoresBean consultaFacultados(int tipoConsulta, ParamGuardaValoresBean paramGuardaValoresBean) {

		ParamGuardaValoresBean parametros = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_Facultados.puestoFacultado:
					parametros = paramGuardaValoresDAO.validaPuestoFacultado(paramGuardaValoresBean, tipoConsulta);
				break;
				case Enum_Con_Facultados.usuarioFacultado:
					parametros = paramGuardaValoresDAO.validaUsuarioFacultado(paramGuardaValoresBean, tipoConsulta);
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Parametros Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return parametros;
	}

	public List<ParamGuardaValoresBean> lista(int tipoLista,  ParamGuardaValoresBean paramGuardaValoresBean) {

		List<ParamGuardaValoresBean> listaParametros = null;
		try{
			switch(tipoLista){
			case Enum_Lis_Parametros.listaPrincipal:
				listaParametros = paramGuardaValoresDAO.listaEmpresa(paramGuardaValoresBean, tipoLista);
			break;
			case Enum_Lis_Parametros.listaFacultados:
				listaParametros = paramGuardaValoresDAO.listaFacultados(paramGuardaValoresBean, Enum_Lis_Parametros.listaPrincipal);
			break;
			case Enum_Lis_Parametros.listaDocumentos:
				listaParametros = paramGuardaValoresDAO.listaDocumentos(paramGuardaValoresBean, Enum_Lis_Parametros.listaPrincipal);
			break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta ", exception);
			exception.printStackTrace();
		}
		return listaParametros;
	}

	private List crearListaFacultador(ParamGuardaValoresBean paramGuardaValoresBean) {
		ArrayList listaFacultados = null;
		ParamGuardaValoresBean paramGuardaValores = null;
		try{
			
			List<String> listaPuestoFacultado 		 = paramGuardaValoresBean.getLisPuestoFacultado();
			List<String> listaUsuarioFacultadoID 	 = paramGuardaValoresBean.getLisUsuarioFacultadoID();
	
			listaFacultados = new ArrayList();
			
			if(listaPuestoFacultado != null){

				int tamanio = listaPuestoFacultado.size();
				for (int iteracion = 0; iteracion < tamanio; iteracion++) {

					paramGuardaValores = new ParamGuardaValoresBean();
					paramGuardaValores.setPuestoFacultado(listaPuestoFacultado.get(iteracion));
					paramGuardaValores.setUsuarioFacultadoID(listaUsuarioFacultadoID.get(iteracion));
					listaFacultados.add(paramGuardaValores);
				}
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido en la creación de los Datos de los Facultados de Parámetros Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaFacultados;
	}

	private List crearListaDocumentos(ParamGuardaValoresBean paramGuardaValoresBean) {
		ArrayList listaDocumentos = null;
		ParamGuardaValoresBean paramGuardaValores = null;
		try{
			
			List<String> listaDocumentoID 	  = paramGuardaValoresBean.getListaDocumentoID();
	
			listaDocumentos = new ArrayList();
			
			if(listaDocumentoID != null){

				int tamanio = listaDocumentoID.size();
				for (int iteracion = 0; iteracion < tamanio; iteracion++) {

					paramGuardaValores = new ParamGuardaValoresBean();
					paramGuardaValores.setDocumentoID(listaDocumentoID.get(iteracion));
					listaDocumentos.add(paramGuardaValores);
				}
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido en la creación de los Datos de Documentos en los Parámetros Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaDocumentos;
	}
	
	public ParamGuardaValoresDAO getParamGuardaValoresDAO() {
		return paramGuardaValoresDAO;
	}

	public void setParamGuardaValoresDAO(ParamGuardaValoresDAO paramGuardaValoresDAO) {
		this.paramGuardaValoresDAO = paramGuardaValoresDAO;
	}

}
