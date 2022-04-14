package nomina.dao;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import nomina.bean.ArchivoInstalBean;
import nomina.bean.ParametrosNominaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ArchivoInstalDAO extends BaseDAO {

	/**
	 * Método que permite crear un nuevo registro historico para la creación del archivo de instalación.
	 * @param archivoInstalBean Información del Folio del archivo de instalación.
	 * @return Mensaje que indica si la acción fue realizada con éxito, y en caso contrario un error que indica el fallo.
	 */
	public MensajeTransaccionBean altaArchivoInstal(final ArchivoInstalBean archivoInstalBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CRENOMINAARCHINSTALALT(?,?,?,?,?,?,?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Descripcion",archivoInstalBean.getDescripcion());
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(archivoInstalBean.getInstitNominaID()));
									sentenciaStore.setInt("Par_ConvenioID",Utileria.convierteEntero(archivoInstalBean.getConvenioNominaID()));

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario() );
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditoArcInstalDAO.altaArchInstal");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							}
							,new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}// public
							}
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de archivos de instalación ", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

	/**
	 * Método que permite modificar un registro existente para el cambio de estatus del archivo de instalación.
	 * @param archivoInstalBean Información del Folio del archivo de instalación.
	 * @param estatus Nuevo estatus que se le asignara al registro.
	 * @return Mensaje que indica si la acción fue realizada con éxito, y en caso contrario un error que indica el fallo.
	 */
	public MensajeTransaccionBean modificaArchivoInstal(final ArchivoInstalBean archivoInstalBean, final String estatus){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CRENOMINAARCHINSTALMOD(?,?,	?,?,?,	?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_FolioID",Utileria.convierteEntero(archivoInstalBean.getFolioID()));
									sentenciaStore.setString("Par_Estatus", estatus);

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario() );
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditoArcInstalDAO.altaArchInstal");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							}
							,new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}// public
							}
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la modificación del archivo de instalación ", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

	/**
	 * Método que permite modificar el EstatusNomina de un determinado crédito, cuando este es enviado por una incidencia.
	 * @param archivoInstalBean Objeto que almacena el identificador del crédito a modificar
	 * @return Mensajes de control.
	 */
	public MensajeTransaccionBean modificarEstatusCredito(final ArchivoInstalBean archivoInstalBean, final int tipoPro, final int folioID){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();
				try{
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CRENOMINAARCHINSTALPRO(?,?,?,?,?	,?,?,?,?,?	,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_FolioID",folioID);
									sentenciaStore.setInt("Par_CreditoID",Utileria.convierteEntero(archivoInstalBean.getCreditoID()));
									sentenciaStore.setInt("Par_NumPro",tipoPro);

									//Parametros de OutPut
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario() );
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditoArcInstalDAO.altaArchInstal");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							}
							,new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}// public
							}
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+" error en la modificación del EstatusNomina del Credito", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

	/**
	 * Método que permite recopilar la información de los créditos para el reporte de instalación de incidencias.
	 * @param tipoRep Variable que indica la información a recopilar por el tipo de reporte.
	 * @param archivoInsta Variable que almacena el folio a consultar.
	 * @return Información de los créditos, clientes y de la institución de nomina.
	 */
	public List<ArchivoInstalBean> listadoCreditosRep(int tipoRep, final ArchivoInstalBean archivoInsta){
		String query = "call CRENOMINAARCHINSTALREP(?,?,	?,?,?,?,?,	?,?);";//mapeo de los campos
		Object[] parametros = {
				Utileria.convierteEntero(archivoInsta.getFolioID()),
				tipoRep,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EmpleadoNominaDAO.listaEmpleado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRENOMINAARCHINSTALLIS(  " + Arrays.toString(parametros) + ")");

		List<ArchivoInstalBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ArchivoInstalBean archivoInstal = new ArchivoInstalBean();

				archivoInstal.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				archivoInstal.setCreditoID(resultSet.getString("CreditoID"));
				archivoInstal.setNumeroEmpleado(resultSet.getString("NumeroEmpleado"));
				archivoInstal.setNombreInstit(resultSet.getString("NombreInstit"));
				archivoInstal.setNombreCompleto(resultSet.getString("NombreCompleto"));
				archivoInstal.setRFC(resultSet.getString("RFC"));
				archivoInstal.setCURP(resultSet.getString("CURP"));
				archivoInstal.setMontoCredito(resultSet.getString("MontoCredito"));
				archivoInstal.setMontoPagare(resultSet.getString("MontoPagare"));
				archivoInstal.setTasaAnual(resultSet.getString("TasaAnual"));
				archivoInstal.setPlazo(resultSet.getString("Plazo"));
				archivoInstal.setNumAmortizacion(resultSet.getString("NumAmortizacion"));
				archivoInstal.setFechaInicioAmor(resultSet.getString("FechaInicioAmor"));
				archivoInstal.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				archivoInstal.setDescuentoPeriodico(resultSet.getString("MontoDescuento"));
				return archivoInstal;
			}
		});
		return matches;
	}

	/**
	 * Método que permite obtener la información de un determinado registro con su correspondiente FolioID.
	 * @param tipoCon Tipo de consulta.
	 * @param archivoInsta Objeto que guarda el identificador del registro.
	 * @return Objeto que guarda la ifnromación del objeto consultado. Devuelve nulo en caso de no encontrar registro con el filtro.
	 */
	public ArchivoInstalBean consultaPrincipal(int tipoCon, final ArchivoInstalBean archivoInsta){
		String query = "call CRENOMINAARCHINSTALCON(?,?,	?,?,?,?,?,	?,?);";//mapeo de los campos
		Object[] parametros = {
				Utileria.convierteEntero(archivoInsta.getFolioID()),
				tipoCon,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EmpleadoNominaDAO.listaEmpleado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRENOMINAARCHINSTALCON(  " + Arrays.toString(parametros) + ")");

		List<ArchivoInstalBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ArchivoInstalBean archivoInstal = new ArchivoInstalBean();

				archivoInstal.setFolioID(resultSet.getString("FolioID"));
				archivoInstal.setInstitNominaID(resultSet.getString("InstitucionID"));
				archivoInstal.setConvenioNominaID(resultSet.getString("ConvenioID"));
				archivoInstal.setDescripcion(resultSet.getString("Descripcion"));

				return archivoInstal;
			}
		});
		return matches.size() > 0 ? (ArchivoInstalBean) matches.get(0) : null;
	}

	/**
	 * Método que permite obtener la información de un determinado registro con su Convenio e institución nomina.
	 * @param tipoCon Tipo de consulta.
	 * @param archivoInsta Objeto que guarda el identificador del registro.
	 * @return Objeto que guarda la información del objeto consultado. Devuelve nulo en caso de no encontrar registro con el filtro.
	 */
	public ArchivoInstalBean consultaArchivoInstal(int tipoCon, final ArchivoInstalBean archivoInsta){
		String query = "call CRENOMINAARCHINSCON(?,?,?,	?,?,?,?,?,	?,?);";//mapeo de los campos
		Object[] parametros = {
				Utileria.convierteEntero(archivoInsta.getInstitNominaID()),
				Utileria.convierteEntero(archivoInsta.getConvenioNominaID()),
				tipoCon,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EmpleadoNominaDAO.listaEmpleado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRENOMINAARCHINSCON(  " + Arrays.toString(parametros) + ")");

		List<ArchivoInstalBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ArchivoInstalBean archivoInstal = new ArchivoInstalBean();

				archivoInstal.setFolioID(resultSet.getString("FolioID"));
				archivoInstal.setInstitNominaID(resultSet.getString("InstitucionID"));
				archivoInstal.setConvenioNominaID(resultSet.getString("ConvenioID"));
				archivoInstal.setDescripcion(resultSet.getString("Descripcion"));
				archivoInstal.setEstatus(resultSet.getString("Estatus"));

				return archivoInstal;
			}
		});
		return matches.size() > 0 ? (ArchivoInstalBean) matches.get(0) : null;
	}

	/**
	 * Método que consulta los primeros 15 resultados con la descripción como filtro.
	 * @param tipoLista Tipo de lista.
	 * @param archivoInsta Objeto que guarda la descripción, el cual se usará como filtro.
	 * @return Objetos coincidentes con el filtro.
	 */
	public List<ArchivoInstalBean> listaPrincipal(int tipoLista, final ArchivoInstalBean archivoInsta){
		String query = "call CRENOMINAARCHINSTALLIS(?,?,	?,?,?,?,?,	?,?);";//mapeo de los campos
		Object[] parametros = {
				archivoInsta.getDescripcion(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EmpleadoNominaDAO.listaEmpleado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRENOMINAARCHINSTALREP(  " + Arrays.toString(parametros) + ")");

		List<ArchivoInstalBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ArchivoInstalBean archivoInstal = new ArchivoInstalBean();

				archivoInstal.setFolioID(resultSet.getString("FolioID"));
				archivoInstal.setInstitNominaID(resultSet.getString("InstitucionID"));
				archivoInstal.setConvenioNominaID(resultSet.getString("ConvenioID"));
				archivoInstal.setDescripcion(resultSet.getString("Descripcion"));

				return archivoInstal;
			}
		});
		return matches;
	}


	/**
	 * Método que permite leer un archivo excel y recuperar la información dentro de el.
	 * @param rutaArchivo ruta física en el cual se almacena el archivo excel.
	 * @return Listado que almacena las listas de éxito y fracaso.
	 */
	public List<List<ArchivoInstalBean>> leerArchivoExcel(String rutaArchivo){
		int contadorError = 0;
		List<ArchivoInstalBean> listaExito = new ArrayList<ArchivoInstalBean>();
		List<ArchivoInstalBean> listaError = new ArrayList<ArchivoInstalBean>();
		List<List<ArchivoInstalBean>> listas = new ArrayList<List<ArchivoInstalBean>>();
		try {
			ArrayList<XSSFRow> listafilas = new ArrayList<XSSFRow>();
			listafilas = readExcelFile(rutaArchivo, 1, 0); // fila 1, hoja 0

			ArchivoInstalBean archivoInstal = null;


			for (int i = 0; i < listafilas.size(); i++) { // Mientras se encuentren resultados
				archivoInstal = new ArchivoInstalBean();

				XSSFCell celda1 = listafilas.get(i).getCell(0); // SolicitudID
				XSSFCell celda2 = listafilas.get(i).getCell(1); // creditoID
				XSSFCell celda3 = listafilas.get(i).getCell(2); // NumeroEmpleado
				XSSFCell celda4 = listafilas.get(i).getCell(3); // Dependencia
				XSSFCell celda5 = listafilas.get(i).getCell(4); // NombreCompleto
				XSSFCell celda6 = listafilas.get(i).getCell(5); // RFC
				XSSFCell celda7 = listafilas.get(i).getCell(6); // CURP
				XSSFCell celda8 = listafilas.get(i).getCell(7); // MontoOtorgado
				XSSFCell celda9 = listafilas.get(i).getCell(8); // MontoPagare
				XSSFCell celda10 = listafilas.get(i).getCell(9); // TasaAnual
				XSSFCell celda11 = listafilas.get(i).getCell(10); // TasaMensual
				XSSFCell celda12 = listafilas.get(i).getCell(11); // Plazo
				XSSFCell celda13 = listafilas.get(i).getCell(12); // NumeroPagos
				XSSFCell celda14 = listafilas.get(i).getCell(13); // DescuentoPeriodico
				XSSFCell celda15 = listafilas.get(i).getCell(14); // PeriodoInicio
				XSSFCell celda16 = listafilas.get(i).getCell(15); // PeriodoFin

				boolean continuar = true;

				if (celda1.getStringCellValue().isEmpty() && celda2.getStringCellValue().isEmpty() &&
						celda3.getStringCellValue().isEmpty() && celda4.getStringCellValue().isEmpty() &&
						celda5.getStringCellValue().isEmpty() && celda6.getStringCellValue().isEmpty() &&
						celda7.getStringCellValue().isEmpty() && celda8.getStringCellValue().isEmpty() &&
						celda9.getStringCellValue().isEmpty() && celda10.getStringCellValue().isEmpty() &&
						celda11.getStringCellValue().isEmpty() && celda12.getStringCellValue().isEmpty() &&
						celda13.getStringCellValue().isEmpty() && celda14.getStringCellValue().isEmpty() &&
						celda15.getStringCellValue().isEmpty() && celda16.getStringCellValue().isEmpty()){
					continue;
				}

				// Se recupera la propiedad SolicitudCreditoID.
				if (continuar) {
					try {
						if (continuar && celda1 != null) {
							if (celda1.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
								archivoInstal.setSolicitudCreditoID(Long.toString((long) celda1.getNumericCellValue()));
							} else {
								archivoInstal.setSolicitudCreditoID(celda1.getStringCellValue());
							}

							if (archivoInstal.getSolicitudCreditoID().isEmpty()){
								continuar = false;
								archivoInstal.setNumError("001");
								archivoInstal.setDescError(" Motivo: Campo Número Solicitud Vacio.");
								archivoInstal.setLineaError(i);
								listaError.add(contadorError, archivoInstal);
								contadorError++;
							}
						} else {
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para el Número de Solicitud.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("001");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para el Número de Solicitud.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad CreditoID.
				if (continuar) {
					try {
						if (continuar && celda2 != null) {
							if (celda2.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
								archivoInstal.setCreditoID(Long.toString((long) celda2.getNumericCellValue()));
							} else {
								archivoInstal.setCreditoID(celda2.getStringCellValue());
							}
						} else {
							continuar = false;
							archivoInstal.setNumError("002");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para el Número de Crédito.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getCreditoID().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Número Credito Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("002");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para el Número de Crédito.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad NumeroEmpleado.
				if (continuar) {
					try {
						if (continuar && celda3 != null) {
							if (celda3.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
								archivoInstal.setNumeroEmpleado(Long.toString((long) celda3.getNumericCellValue()));
							} else {
								archivoInstal.setNumeroEmpleado(celda3.getStringCellValue());
							}
						} else {
							continuar = false;
							archivoInstal.setNumError("003");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para el Número Empleado.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getNumeroEmpleado().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Número Empleado Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("003");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para el Número Empleado.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad Dependencia.
				if (continuar) {
					try {
						if (continuar && celda4 != null) {

							archivoInstal.setNombreInstNomina(celda4.getStringCellValue());

						} else {
							continuar = false;
							archivoInstal.setNumError("004");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para la Dependencia.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getNombreInstNomina().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Dependencia Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("004");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para la Dependencia.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad NombreCompleto.
				if (continuar) {
					try {
						if (continuar && celda5 != null) {

							archivoInstal.setNombreCompleto(celda5.getStringCellValue());

						} else {
							continuar = false;
							archivoInstal.setNumError("005");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para el Nombre Completo.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getNombreCompleto().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Nombre Completo Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("005");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para el Nombre Completo.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad RFC.
				if (continuar) {
					try {
						if (continuar && celda6 != null) {

							archivoInstal.setRFC(celda6.getStringCellValue());

						} else {
							continuar = false;
							archivoInstal.setNumError("006");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para el RFC.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getRFC().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo RFC Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("006");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para el RFC.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad CURP.
				if (continuar) {
					try {
						if (continuar && celda7 != null) {

							archivoInstal.setCURP(celda7.getStringCellValue());

						} else {
							continuar = false;
							archivoInstal.setNumError("007");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para el CURP.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getCURP().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo CURP Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("007");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para el CURP.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad MontoCredito.
				if (continuar) {
					try {
						if (continuar && celda8 != null) {
							if (celda8.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
								archivoInstal.setMontoCredito(Double.toString((celda8.getNumericCellValue())));
							} else {
								archivoInstal.setMontoCredito(celda8.getStringCellValue());
							}
						} else {
							continuar = false;
							archivoInstal.setNumError("008");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para el Monto Otorgado.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getMontoCredito().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Monto Credito Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("008");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para el Monto Otorgado.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad MontoPagare.
				if (continuar) {
					try {
						if (continuar && celda9 != null) {
							if (celda9.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
								archivoInstal.setMontoPagare(Double.toString((celda9.getNumericCellValue())));
							} else {
								archivoInstal.setMontoPagare(celda9.getStringCellValue());
							}
						} else {
							continuar = false;
							archivoInstal.setNumError("009");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para el Monto Pagare.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getMontoPagare().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Monto Pagare Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("009");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para el Monto Pagare.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad Tasa Anual.
				if (continuar) {
					try {
						if (continuar && celda10 != null) {
							if (celda10.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
								archivoInstal.setTasaAnual(Double.toString(celda10.getNumericCellValue()));
							} else {
								archivoInstal.setTasaAnual(celda10.getStringCellValue());
							}
						} else {
							continuar = false;
							archivoInstal.setNumError("010");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para la Tasa Anual.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getTasaAnual().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Tasa Anual Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("010");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para la Tasa Anual.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad TasaMensual.
				if (continuar) {
					try {
						if (continuar && celda11 != null) {
							if (celda11.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
								archivoInstal.setTasaMensual(Double.toString(celda11.getNumericCellValue()));
							} else {
								archivoInstal.setTasaMensual(celda11.getStringCellValue());
							}
						} else {
							continuar = false;
							archivoInstal.setNumError("011");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para la Tasa Mensual.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getTasaMensual().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Tasa Mensual Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("011");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para la Tasa Mensual.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}
				// Se recupera la propiedad Plazo.
				if (continuar) {
					try {
						if (continuar && celda12 != null) {

							archivoInstal.setPlazo(celda12.getStringCellValue());

						} else {
							continuar = false;
							archivoInstal.setNumError("012");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para el Plazo.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getPlazo().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Plazo Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("012");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para el Plazo.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad NumAmortizacion.
				if (continuar) {
					try {
						if (continuar && celda13 != null) {
							if (celda13.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
								archivoInstal.setNumAmortizacion(Long.toString((long) celda13.getNumericCellValue()));
							} else {
								archivoInstal.setNumAmortizacion(celda13.getStringCellValue());
							}
						} else {
							continuar = false;
							archivoInstal.setNumError("013");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para el Número de Pagos.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getNumAmortizacion().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Número Pagos Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("013");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para el Número de Pagos.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad DescuentoPeriodico.
				if (continuar) {
					try {
						if (continuar && celda14 != null) {
							if (celda14.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
								archivoInstal.setDescuentoPeriodico(Double.toString(celda14.getNumericCellValue()));
							} else {
								archivoInstal.setDescuentoPeriodico(celda14.getStringCellValue());
							}
						} else {
							continuar = false;
							archivoInstal.setNumError("014");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para el Descuento Periódico.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getDescuentoPeriodico().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Descuento Periodico Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("014");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para el Descuento Periódico.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad FechaInicioAmor.
				if (continuar) {
					try {
						if (continuar && celda15 != null) {

							archivoInstal.setFechaInicioAmor(celda15.getStringCellValue());

						} else {
							continuar = false;
							archivoInstal.setNumError("015");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para la fecha de periodo de inicio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getFechaInicioAmor().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Periodo Inicio Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("015");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para la fecha de periodo de inicio.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}

				// Se recupera la propiedad FechaVencimiento.
				if (continuar) {
					try {
						if (continuar && celda16 != null) {

							archivoInstal.setFechaVencimiento(celda16.getStringCellValue());

						} else {
							continuar = false;
							archivoInstal.setNumError("016");
							archivoInstal.setDescError(" Motivo: Formato incorrecto para la fecha de periodo del fin.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (archivoInstal.getFechaVencimiento().isEmpty()){
							continuar = false;
							archivoInstal.setNumError("001");
							archivoInstal.setDescError(" Motivo: Campo Fecha Fin Vacio.");
							archivoInstal.setLineaError(i);
							listaError.add(contadorError, archivoInstal);
							contadorError++;
						}
						if (continuar) {
							archivoInstal.setLineaError(i);
							listaExito.add(archivoInstal);
						}
					} catch (Exception e) {
						continuar = false;
						archivoInstal.setNumError("016");
						archivoInstal.setDescError(" Motivo: Formato incorrecto para la fecha de periodo del fin.");
						archivoInstal.setLineaError(i);
						listaError.add(contadorError, archivoInstal);
						contadorError++;
					}
				}
			}
		} catch (Exception e){
			e.printStackTrace();
			listas.add(listaExito);
			listas.add(listaError);
			return listas;
		}
		listas.add(listaExito);
		listas.add(listaError);

		return listas;
	}


	/**
	 * Método que permite leer un archivo excel y obtener la información en objetos HSSFRow.
	 * @param fileName Nombre del archivo almacenado en el servidor.
	 * @param filaInicio Fila de inicio de la lectura.
	 * @param numHoja Numero de hoja a leer.
	 * @return Información del excel.
	 */
	private ArrayList<XSSFRow> readExcelFile(String fileName, int filaInicio, int numHoja) {
		String rutaArch = fileName;
		ArrayList<XSSFRow> list = new ArrayList<XSSFRow>();
		try {
			//POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(rutaArch));
			FileInputStream fis = new FileInputStream(fileName);
			XSSFWorkbook libro = new XSSFWorkbook(fis);

			XSSFSheet hoja = libro.getSheetAt(numHoja);
			XSSFRow fila;

			Iterator iterator = hoja.rowIterator();
			while (iterator.hasNext()) {
				fila = hoja.getRow(filaInicio);

				if (fila != null) {
					list.add(fila);
				}
				iterator.next();
				filaInicio++;
			}
		} catch (IOException e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en leer archivo de excel .XLS", e);
			list = null;
		}

		return list;
	}

}
