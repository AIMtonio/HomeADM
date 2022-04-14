package pld.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Archivos;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import pld.bean.OpIntPreocupantesBean;
import pld.bean.PLDCNBVOpeIntPreBean;
import pld.bean.ReportesSITIBean;
import pld.reporte.ReporteSITIControlador.Enum_Con_TipRepor;
import pld.servicio.OpIntPreocupantesServicio.Enum_Tra_OpIntPreocupantes;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class OpIntPreocupantesDAO extends BaseDAO{

	private ParametrosSisServicio parametrosSisServicio = null;

	public OpIntPreocupantesDAO() {
		super();
	}


	/*------------Alta de Operaciones-------------*/
	public MensajeTransaccionBean alta(final OpIntPreocupantesBean opIntPreocupantesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccionOpeInusuales(opIntPreocupantesBean.getOrigenDatos());
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(opIntPreocupantesBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(opIntPreocupantesBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDOPEINTERPREOALT("
														+ "?,?,?,?,?,	"
														+ "?,?,?,?,?,	"
														+ "?,?,?,?,?,	"
														+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_CatProcedIntID",opIntPreocupantesBean.getCatProcedIntID());
									sentenciaStore.setString("Par_CatMotivPreoID",opIntPreocupantesBean.getCatMotivPreoID());
									sentenciaStore.setString("Par_FechaDeteccion",opIntPreocupantesBean.getFechaDeteccion());
									sentenciaStore.setInt("Par_ClavePersonaInv",Utileria.convierteEntero(opIntPreocupantesBean.getClavePersonaInv()));
									sentenciaStore.setString("Par_NomPersonaInv",opIntPreocupantesBean.getNomPersonaInv());

									sentenciaStore.setString("Par_CteInvolucrado",opIntPreocupantesBean.getCteInvolucrado());
									sentenciaStore.setString("Par_Frecuencia",opIntPreocupantesBean.getFrecuencia());
									sentenciaStore.setString("Par_DesFrecuencia",opIntPreocupantesBean.getDesFrecuencia());
									sentenciaStore.setString("Par_DesOperacion",opIntPreocupantesBean.getDesOperacion());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(opIntPreocupantesBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OpIntPreocupantesDAO.alta");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + ".OpIntPreocupantesDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(opIntPreocupantesBean.getOrigenDatos()+"-"+"error en alta de operaciones internas preocupantes: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public OpIntPreocupantesBean consultaPrincipal(OpIntPreocupantesBean opIntPreocupantes, int tipoConsulta){

		String query = "call PLDOPEINTERPREOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				opIntPreocupantes.getOpeInterPreoID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				"OpIntPreocupantesDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINTERPREOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpIntPreocupantesBean opInt = new OpIntPreocupantesBean();
				opInt.setOpeInterPreoID(resultSet.getString("OpeInterPreoID"));
				opInt.setCatProcedIntID(resultSet.getString("CatProcedIntID"));
				opInt.setCatMotivPreoID(resultSet.getString("CatMotivPreoID"));
				opInt.setFechaDeteccion(resultSet.getString("FechaDeteccion"));
				opInt.setCategoriaID(resultSet.getString("CategoriaID"));
				opInt.setSucursalID(resultSet.getString("SucursalID"));
				opInt.setClavePersonaInv(resultSet.getString("ClavePersonaInv"));
				opInt.setNomPersonaInv(resultSet.getString("NomPersonaInv"));
				opInt.setCteInvolucrado(resultSet.getString("CteInvolucrado"));
				opInt.setFrecuencia(resultSet.getString("Frecuencia"));
				opInt.setDesFrecuencia(resultSet.getString("DesFrecuencia"));
				opInt.setDesOperacion(resultSet.getString("DesOperacion"));
				opInt.setEstatus(resultSet.getString("Estatus"));
				opInt.setComentarioOC(resultSet.getString("ComentarioOC"));
				opInt.setFechaCierre(resultSet.getString("FechaCierre"));
				opInt.setFecha(resultSet.getString("Fecha"));
				return opInt;
			}
		});
		return matches.size() > 0 ? (OpIntPreocupantesBean) matches.get(0) : null;
	}


	//sss
	public OpIntPreocupantesBean consultaNombreArchivo(OpIntPreocupantesBean opIntPreocupantes, int tipoConsulta){

		String query = "call PLDOPEINTERPREOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				"OpIntPreocupantesDAO.consultaNombreArchivo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINTERPREOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpIntPreocupantesBean opInt = new OpIntPreocupantesBean();
				opInt.setNombreArchivo(resultSet.getString("nombreArchivo"));

				return opInt;
			}
		});
		return matches.size() > 0 ? (OpIntPreocupantesBean) matches.get(0) : null;
	}


	//consulta datos para generar el txt
	public List consultaDatosReporteTXT(OpIntPreocupantesBean opIntPreocupantesBean, int tipoLista, long numTransaccion){

		List matches=null;
		try{
			String query = "call PLDOPEINTERPREOLIS(?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
			Object[] parametros = {
					opIntPreocupantesBean.getPeriodoInicio(),
					opIntPreocupantesBean.getPeriodoFin(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,

					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,

					"OpIntPreocupantesDAO.consultaDatosReporteTXT",
					Constantes.ENTERO_CERO,
					numTransaccion
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINTERPREOLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
			matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PLDCNBVOpeIntPreBean opInt = new PLDCNBVOpeIntPreBean();

					opInt.setTipoReporte(resultSet.getString("TipoDeReporte"));
					opInt.setPeriodoReporte(resultSet.getString("Periodo"));
					opInt.setFolio(resultSet.getString("Folio"));
					opInt.setClaveOrgSupervisor(resultSet.getString("OrganoSup"));
					opInt.setClaveEntCasFim(resultSet.getString("ClaveCasfim"));

					opInt.setLocalidadSuc(resultSet.getString("LocalidadSuc"));
					opInt.setSucursalCP(resultSet.getString("SucursalCP"));
					opInt.setTipoOperacionID(resultSet.getString("TipoOperacion"));
					opInt.setInstrumentMonID(resultSet.getString("InstrumentoMon"));
					opInt.setCuentaAhoID(resultSet.getString("NumCuenta"));

					opInt.setMonto(resultSet.getString("MontoOperacion"));
					opInt.setClaveMoneda(resultSet.getString("Moneda"));
					opInt.setFechaOpe(resultSet.getString("FechaOperacion"));
					opInt.setFechaDeteccion(resultSet.getString("FechaDeteccion"));
					opInt.setNacionalidad(resultSet.getString("Nacionalidad"));

					opInt.setTipoPersona(resultSet.getString("TipoDePersona"));
					opInt.setRazonSocial(resultSet.getString("RazonSocioal"));
					opInt.setNombre(resultSet.getString("Nombre"));
					opInt.setApellidoPat(resultSet.getString("ApellidoPaterno"));
					opInt.setApellidoMat(resultSet.getString("ApellidoMaterno"));

					opInt.setRFC(resultSet.getString("RFC"));
					opInt.setCURP(resultSet.getString("CURP"));
					opInt.setFechaNac(resultSet.getString("FechaNacimiento"));
					opInt.setDomicilio(resultSet.getString("Domicilio"));
					opInt.setColonia(resultSet.getString("Colonia"));

					opInt.setLocalidad(resultSet.getString("Localidad"));
					opInt.setTelefono(resultSet.getString("Telefonos"));
					opInt.setActEconomica(resultSet.getString("ActividadEconomica"));
					opInt.setNomApoderado(resultSet.getString("NombreApoSeguros"));
					opInt.setApPatApoderado(resultSet.getString("ApellidoPaternoApoSeguros"));

					opInt.setApMatApoderado(resultSet.getString("ApellidoMaternoApoSeguros"));
					opInt.setRFCApoderado(resultSet.getString("RFCApoSeguros"));
					opInt.setCURPApoderado(resultSet.getString("CURPApoSeguros"));
					opInt.setConsecutivoCta(resultSet.getString("ConsecutivoCuenta"));
					opInt.setCtaRelacionadoID(resultSet.getString("NumCuentaRelacionado"));

					opInt.setClaveCasfimRelacionado(resultSet.getString("ClaveCasfimRelacionado"));
					opInt.setNombreRelacionado(resultSet.getString("NombreRelacionado"));
					opInt.setApPatRelacionado(resultSet.getString("ApellidoPaternoRelacionado"));
					opInt.setApMatRelacionado(resultSet.getString("ApellidoMaternoRelacionado"));
					opInt.setDesOperacion(resultSet.getString("DescriOperacion"));

					opInt.setRazones(resultSet.getString("DescriMotivo"));

					return opInt;
				}
			});

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de datos reporte", e);
		}
		return matches;
	}

	/**
	 * Pasa a la tabla histórica y a la tabla del reporte cnbv todas las operaciones generadas en el periodo
	 * y genera el reporte (archivo separado por punto y coma) dependiendo del tipo de institución financiera
	 * parametrizada en INSTITUCIONES y en PARAMETROSSIS.
	 * @author avelasco
	 * @param reporteOpIntPreocBean {@link OpIntPreocupantesBean} con los parámetros de entrada al(los) SP(s).
	 * @param listaReporte Tipo de reporte a generar (número de consulta).
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 */
	public MensajeTransaccionBean altaHistoricoGeneraReporte(final OpIntPreocupantesBean reporteOpIntPreocBean, final int listaReporte) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		final long numTransaccion = transaccionDAO.generaNumeroTransaccionOut();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				String nombreArchivo = Constantes.STRING_VACIO;
				String rutaArchivo = Constantes.STRING_VACIO;
				List ListaOperacionParaArchivo = null;
				String tipoInstitucion = "";

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Alta en histórico de las operaciones reportadas.
					mensajeBean = altaHisOpeIntPreo(reporteOpIntPreocBean,numTransaccion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					// Generación del reporte en formato SITI de las operaciones reportadas.
					mensajeBean = generaArchivo(reporteOpIntPreocBean, listaReporte, numTransaccion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					// Actualización de las operaciones para que no vuelvan a ser generadas.
					actHisOpeIntPreo(reporteOpIntPreocBean,Enum_Tra_OpIntPreocupantes.actEstatusSITI,numTransaccion);
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico general de reporte: ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}finally{
					mensajeBean.setCampoGenerico(nombreArchivo);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Genera la lista de Operaciones a Reportar para generar el reporte en formato excel.
	 * @param reporteOpIntPreocBean {@link ReportesSITIBean} con los parámetros de entrada a los SPs.
	 * @param listaReporte Número de lista.
	 * @return Lista con las operaciones a reportar.
	 */
	public List listaReporteExcel(final ReportesSITIBean reporteOpIntPreocBean, final int listaReporte) {
		List listaOperacionParaArchivo = null;
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		final long numTransaccion = transaccionDAO.generaNumeroTransaccionOut();
		try {
			mensajeBean = altaHisOpeIntPreo(reporteOpIntPreocBean,numTransaccion);
			if(mensajeBean.getNumero()!=0){
				throw new Exception(mensajeBean.getDescripcion());
			}

			listaOperacionParaArchivo = consultaDatosReporte(reporteOpIntPreocBean, listaReporte, numTransaccion);

		} catch (Exception e) {
			if(mensajeBean.getNumero()==0){
				mensajeBean.setNumero(999);
			}
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-error en alta historico general de reporte op. int. preocupantes: ", e);
		}
		return listaOperacionParaArchivo;
	}

	public MensajeTransaccionBean actHisOpeIntPreo(final OpIntPreocupantesBean reporteOpIntPreocBean, final int numActualizacion, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call HISPLDOPEINTERPREACT("
														+ "?,?,?,?,?,	"
														+ "?,?,?,?,?,	"
														+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setDate("Par_PeriodoInicio",OperacionesFechas.conversionStrDate(reporteOpIntPreocBean.getPeriodoInicio()));
									sentenciaStore.setDate("Par_PeriodoFin",OperacionesFechas.conversionStrDate(reporteOpIntPreocBean.getPeriodoFin()));
									sentenciaStore.setString("Par_NombreReporte",(reporteOpIntPreocBean.getRutaArchivosPLD() + reporteOpIntPreocBean.getNombreArchivo()));
									sentenciaStore.setInt("Par_NumAct", numActualizacion);
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",(parametrosAuditoriaBean.getEmpresaID()));
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OpIntPreocupantesDAO.altaHisOpeIntPreo");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + ".OpIntPreocupantesDAO.altaHisOpeIntPreo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico internas preocupantes: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean altaHisOpeIntPreo(final OpIntPreocupantesBean reporteOpIntPreocBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call HISPLDOPEINTERPREALT("
														+ "?,?,?,?,?,	"
														+ "?,?,?,?,?,	"
														+ "?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setDate("Par_PeriodoInicio",OperacionesFechas.conversionStrDate(reporteOpIntPreocBean.getPeriodoInicio()));
									sentenciaStore.setDate("Par_PeriodoFin",OperacionesFechas.conversionStrDate(reporteOpIntPreocBean.getPeriodoFin()));
									sentenciaStore.setString("Par_EstatusSITI",Constantes.STRING_SI);
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",(parametrosAuditoriaBean.getEmpresaID()));
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OpIntPreocupantesDAO.altaHisOpeIntPreo");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + ".OpIntPreocupantesDAO.altaHisOpeIntPreo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico internas preocupantes: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean altaHisOpeIntPreo(final ReportesSITIBean reporteOpIntPreocBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call HISPLDOPEINTERPREALT("
														+ "?,?,?,?,?,	"
														+ "?,?,?,?,?,	"
														+ "?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setDate("Par_PeriodoInicio",OperacionesFechas.conversionStrDate(reporteOpIntPreocBean.getPeriodoInicio()));
									sentenciaStore.setDate("Par_PeriodoFin",OperacionesFechas.conversionStrDate(reporteOpIntPreocBean.getPeriodoFin()));
									sentenciaStore.setString("Par_EstatusSITI",Constantes.STRING_NO);
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",(parametrosAuditoriaBean.getEmpresaID()));
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .OpIntPreocupantesDAO.altaHisOpeIntPreo");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .OpIntPreocupantesDAO.altaHisOpeIntPreo");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico internas preocupantes", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Genera el Archivo
	public MensajeTransaccionBean generaArchivo(final OpIntPreocupantesBean opIntPreocupantes, final int tipoListaReporte, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		// Se obtiene el tipo de institucion financiera
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
		final String tipoInstitucion = parametrosSisBean.getNombreCortoInst();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {

				String nombreArchivo = Constantes.STRING_VACIO;
				String rutaArchivo = Constantes.STRING_VACIO;
				List ListaOperacionParaArchivo = null;

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					ListaOperacionParaArchivo = consultaDatosReporteTXT(opIntPreocupantes, tipoListaReporte, numTransaccion);

					String[] columnas = null;
					/* Genera el archivo con los campos de acuerdo al tipo de institucion */
					if(tipoInstitucion.equals("scap")||tipoInstitucion.equals("socap")||tipoInstitucion.equals("sofipo")){
						columnas = new String[]{
							"tipoReporte",			  "periodoReporte",		"folio",			"claveOrgSupervisor",	"claveEntCasFim",
							"localidadSuc",		  	  "sucursalCP",			"tipoOperacionID",	"instrumentMonID",		"cuentaAhoID",
							"monto",				  "claveMoneda",	 	"fechaOpe",			"fechaDeteccion",		"nacionalidad",
							"tipoPersona",			  "razonSocial",	    "nombre",			"apellidoPat",			"apellidoMat",
							"RFC",					  "CURP",			    "fechaNac",			"domicilio",			"colonia",
							"localidad",			  "telefono",			"actEconomica",		"nomApoderado",			"apPatApoderado",
							"apMatApoderado",		  "RFCApoderado",		"CURPApoderado",	"consecutivoCta",		"ctaRelacionadoID",
							"claveCasfimRelacionado","nombreRelacionado",	"apPatRelacionado",	"apMatRelacionado",		"desOperacion",
							"razones"};
					}else{
						columnas = new String[]{
							"tipoReporte",			  "periodoReporte",		"folio",			"claveOrgSupervisor",	"claveEntCasFim",
							"localidadSuc",		  	  "sucursalCP",			"tipoOperacionID",	"instrumentMonID",		"cuentaAhoID",
							"monto",				  "claveMoneda",	 	"fechaOpe",			"fechaDeteccion",		"nacionalidad",
							"tipoPersona",			  "razonSocial",	    "nombre",			"apellidoPat",			"apellidoMat",
							"RFC",					  "CURP",			    "fechaNac",			"domicilio",			"colonia",
							"localidad",			  "telefono",			"actEconomica",		"consecutivoCta",		"ctaRelacionadoID",
							"claveCasfimRelacionado","nombreRelacionado",	"apPatRelacionado",	"apMatRelacionado",		"desOperacion",
							"razones"};
					}

					nombreArchivo = opIntPreocupantes.getNombreArchivo();
					rutaArchivo= opIntPreocupantes.getRutaArchivosPLD();
					loggerSAFI.info("Generacion del Reporte de Operaciones Int. Preocupantes: ["+rutaArchivo+nombreArchivo+"]");
					Archivos archivoTXT= new Archivos();
					nombreArchivo  = archivoTXT.EscribeArchivoTexto(ListaOperacionParaArchivo, columnas, PLDCNBVOpeIntPreBean.class.getName(),rutaArchivo, nombreArchivo , "txt", ";");

					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Archivo Generado con Exito");
					mensajeBean.setNombreControl("fechaActual");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();

					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al generar archivo interno", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}finally{
					mensajeBean.setCampoGenerico(nombreArchivo);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}




	/* Actualización  */
	public MensajeTransaccionBean actualizacion(final OpIntPreocupantesBean opIntPreocupantes) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query cons el Store Procedure
					String query = "call PLDOPEINTERPREOACT(?,?,?);";
					Object[] parametros = {
							opIntPreocupantes.getOpeInterPreoID(),
							opIntPreocupantes.getEstatus(),
							opIntPreocupantes.getComentarioOC(),
					};

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINTERPREOACT(" + Arrays.toString(parametros) + ")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));

							return mensaje;

						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();

					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de operacion interno preocupante", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public List listaAlfanumerica(OpIntPreocupantesBean opIntPreocupantesBean, int tipoLista){
		String query = "call PLDOPEINTERPREOLIS(?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
		Object[] parametros = {
				Constantes.FECHA_VACIA,
				Constantes.FECHA_VACIA,
				opIntPreocupantesBean.getCategoriaID(),
				opIntPreocupantesBean.getSucursalID(),
				opIntPreocupantesBean.getNomPersonaInv(),

				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"OpIntPreocupantesDAO.listaAlfanumerica",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINTERPREOLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(opIntPreocupantesBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpIntPreocupantesBean opIntPreocupantesBean = new OpIntPreocupantesBean();
				opIntPreocupantesBean.setClavePersonaInv(resultSet.getString(1));
				opIntPreocupantesBean.setNomPersonaInv(resultSet.getString(2));

				return opIntPreocupantesBean;
			}
		});
		return matches;
	}

	public List listaCompleta(OpIntPreocupantesBean opIntPreocupantesBean, int tipoLista){
		String query = "call PLDOPEINTERPREOLIS(?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
		Object[] parametros = {
				Constantes.FECHA_VACIA,
				Constantes.FECHA_VACIA,
				Utileria.convierteEntero(opIntPreocupantesBean.getCategoriaID()),
				Utileria.convierteEntero(opIntPreocupantesBean.getSucursalID()),
				opIntPreocupantesBean.getNomPersonaInv(),

				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"OpIntPreocupantesDAO.listaCompleta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINTERPREOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(opIntPreocupantesBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpIntPreocupantesBean opIntPreocupantesBean = new OpIntPreocupantesBean();
				opIntPreocupantesBean.setClavePersonaInv(resultSet.getString(1));
				opIntPreocupantesBean.setNomPersonaInv(resultSet.getString(2));

				return opIntPreocupantesBean;
			}
		});
		return matches;
	}


	public List listaFiltroA(OpIntPreocupantesBean opIntPreocupantesBean, int tipoLista){
		String query = "call PLDOPEINTERPREOLIS(?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
		Object[] parametros = {
				Constantes.FECHA_VACIA,
				Constantes.FECHA_VACIA,
				opIntPreocupantesBean.getCategoriaID(),
				Utileria.convierteEntero(opIntPreocupantesBean.getSucursalID()),
				opIntPreocupantesBean.getNomPersonaInv(),

				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"OpIntPreocupantesDAO.listaFiltroA",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINTERPREOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(opIntPreocupantesBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpIntPreocupantesBean opIntPreocupantesBean = new OpIntPreocupantesBean();
				opIntPreocupantesBean.setClavePersonaInv(resultSet.getString(1));
				opIntPreocupantesBean.setNomPersonaInv(resultSet.getString(2));

				return opIntPreocupantesBean;

			}
		});
		return matches;
	}

	public List listaFiltroB(OpIntPreocupantesBean opIntPreocupantesBean, int tipoLista){
		String query = "call PLDOPEINTERPREOLIS(?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
		Object[] parametros = {
				Constantes.FECHA_VACIA,
				Constantes.FECHA_VACIA,
				Utileria.convierteEntero(opIntPreocupantesBean.getCategoriaID()),
				opIntPreocupantesBean.getSucursalID(),
				opIntPreocupantesBean.getNomPersonaInv(),

				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"OpIntPreocupantesDAO.listaFiltroB",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINTERPREOLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(opIntPreocupantesBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpIntPreocupantesBean opIntPreocupantesBean = new OpIntPreocupantesBean();
				opIntPreocupantesBean.setClavePersonaInv(resultSet.getString(1));
				opIntPreocupantesBean.setNomPersonaInv(resultSet.getString(2));

				return opIntPreocupantesBean;

			}
		});
		return matches;
	}

	public List listaOpeIntPreocupantes(OpIntPreocupantesBean opIntPreocupantesBean, int tipoLista){
		String query = "call PLDOPEINTERPREOLIS(?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
		Object[] parametros = {
				Constantes.FECHA_VACIA,
				Constantes.FECHA_VACIA,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				opIntPreocupantesBean.getOpeInterPreoID(),

				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"OpIntPreocupantesDAO.listaOpeIntPreocupantes",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINTERPREOLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpIntPreocupantesBean opIntPreocupantesBean = new OpIntPreocupantesBean();
				opIntPreocupantesBean.setOpeInterPreoID(resultSet.getString("OpeInterPreoID"));
				opIntPreocupantesBean.setNomPersonaInv(resultSet.getString("NomPersonaInv"));
				opIntPreocupantesBean.setFechaDeteccion(resultSet.getString("FechaDeteccion"));

				return opIntPreocupantesBean;
			}
		});
		return matches;
	}

	public List listaOpeIntPreocupantesExterna(OpIntPreocupantesBean opIntPreocupantesBean, int tipoLista){
		String query = "call PLDOPEINTERPREOLIS(?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
		Object[] parametros = {
				Constantes.FECHA_VACIA,
				Constantes.FECHA_VACIA,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				opIntPreocupantesBean.getOpeInterPreoID(),

				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"OpIntPreocupantesDAO.listaOpeIntPreocupantesExterna",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINTERPREOLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(opIntPreocupantesBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpIntPreocupantesBean opIntPreocupantesBean = new OpIntPreocupantesBean();
				opIntPreocupantesBean.setOpeInterPreoID(resultSet.getString("OpeInterPreoID"));
				opIntPreocupantesBean.setNomPersonaInv(resultSet.getString("NomPersonaInv"));
				opIntPreocupantesBean.setFechaDeteccion(resultSet.getString("FechaDeteccion"));

				return opIntPreocupantesBean;
			}
		});
		return matches;
	}

	//consulta datos para generar el txt
	public List consultaDatosReporte(ReportesSITIBean opIntPreocupantesBean,int tipoLista, final long numTransaccion){
		List matches=null;
		try{
			String query = "call PLDOPEINTERPREOLIS(?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
			Object[] parametros = {
					opIntPreocupantesBean.getPeriodoInicio(),
					opIntPreocupantesBean.getPeriodoFin(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,

					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,

					"OpIntPreocupantesDAO.consultaDatosReporteTXT",
					Constantes.ENTERO_CERO,
					numTransaccion
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINTERPREOLIS(" + Arrays.toString(parametros) + ")");
			matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReportesSITIBean opInt = new ReportesSITIBean();

					opInt.setTipoReporte(resultSet.getString("TipoDeReporte"));
					opInt.setPeriodoReporte(resultSet.getString("Periodo"));
					opInt.setFolio(resultSet.getString("Folio"));
					opInt.setClaveOrgSupervisor(resultSet.getString("OrganoSup"));
					opInt.setClaveEntCasFim(resultSet.getString("ClaveCasfim"));

					opInt.setLocalidadSuc(resultSet.getString("LocalidadSuc"));
					opInt.setSucursalID(resultSet.getString("SucursalCP"));
					opInt.setTipoOperacionID(resultSet.getString("TipoOperacion"));
					opInt.setInstrumentMonID(resultSet.getString("InstrumentoMon"));
					opInt.setCuentaAhoID(resultSet.getString("NumCuenta"));

					opInt.setMonto(resultSet.getString("MontoOperacion"));
					opInt.setClaveMoneda(resultSet.getString("Moneda"));
					opInt.setFechaOpe(resultSet.getString("FechaOperacion"));
					opInt.setFechaDeteccion(resultSet.getString("FechaDeteccion"));
					opInt.setNacionalidad(resultSet.getString("Nacionalidad"));

					opInt.setTipoPersona(resultSet.getString("TipoDePersona"));
					opInt.setRazonSocial(resultSet.getString("RazonSocioal"));
					opInt.setNombre(resultSet.getString("Nombre"));
					opInt.setApellidoPat(resultSet.getString("ApellidoPaterno"));
					opInt.setApellidoMat(resultSet.getString("ApellidoMaterno"));

					opInt.setRFC(resultSet.getString("RFC"));
					opInt.setCURP(resultSet.getString("CURP"));
					opInt.setFechaNac(resultSet.getString("FechaNacimiento"));
					opInt.setDomicilio(resultSet.getString("Domicilio"));
					opInt.setColonia(resultSet.getString("Colonia"));

					opInt.setLocalidad(resultSet.getString("Localidad"));
					opInt.setTelefono(resultSet.getString("Telefonos"));
					opInt.setActEconomica(resultSet.getString("ActividadEconomica"));
					opInt.setNomApoderado(resultSet.getString("NombreApoSeguros"));
					opInt.setApPatApoderado(resultSet.getString("ApellidoPaternoApoSeguros"));

					opInt.setApMatApoderado(resultSet.getString("ApellidoMaternoApoSeguros"));
					opInt.setRFCApoderado(resultSet.getString("RFCApoSeguros"));
					opInt.setCURPApoderado(resultSet.getString("CURPApoSeguros"));
					opInt.setCtaRelacionadoID(resultSet.getString("ConsecutivoCuenta"));
					opInt.setCuenAhoRelacionado(resultSet.getString("NumCuentaRelacionado"));

					opInt.setClaveCasfimRelacionado(resultSet.getString("ClaveCasfimRelacionado"));
					opInt.setNomTitular(resultSet.getString("NombreRelacionado"));
					opInt.setApPatTitular(resultSet.getString("ApellidoPaternoRelacionado"));
					opInt.setApMatTitular(resultSet.getString("ApellidoMaternoRelacionado"));
					opInt.setDesOperacion(resultSet.getString("DescriOperacion"));

					opInt.setRazones(resultSet.getString("DescriMotivo"));

					return opInt;
				}
			});

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de datos reporte", e);
		}
		return matches;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}


	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

}