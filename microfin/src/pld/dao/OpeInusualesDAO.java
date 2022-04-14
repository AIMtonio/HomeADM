package pld.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
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

import javax.servlet.http.HttpServletResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import pld.bean.OpeInusualesBean;
import pld.bean.PLDCNBVopeInuBean;
import pld.bean.ReportesSITIBean;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosSisBean;
import soporte.dao.ParametrosSisDAO;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;


public class OpeInusualesDAO extends BaseDAO{
	private ParametrosSisServicio parametrosSisServicio = null;

	public OpeInusualesDAO() {
		super();
	}


	/*------------Alta de Operaciones-------------*/
	public MensajeTransaccionBean alta(final OpeInusualesBean opeInusualesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccionOpeInusuales(opeInusualesBean.getOrigenDatos());
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(opeInusualesBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(opeInusualesBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
			/*---------------Query con el SP-------------*/
							String query = "call PLDOPEINUSUALESALT(?,?,?,?,?,   ?,?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							/*Object[] parametros = {*/
							sentenciaStore.setString("Par_CatProcedIntID",opeInusualesBean.getCatProcedIntID());
							sentenciaStore.setString("Par_CatMotivInuID",opeInusualesBean.getCatMotivInuID());
							sentenciaStore.setDate("Par_FechaDeteccion",OperacionesFechas.conversionStrDate(opeInusualesBean.getFechaDeteccion()));
							sentenciaStore.setInt("Par_ClavePersonaInv",Utileria.convierteEntero(opeInusualesBean.getClavePersonaInv()));
							sentenciaStore.setString("Par_NomPersonaInv",opeInusualesBean.getNomPersonaInv());

							sentenciaStore.setString("Par_EmpInvolucrado",opeInusualesBean.getEmpInvolucrado());
							sentenciaStore.setString("Par_Frecuencia",opeInusualesBean.getFrecuencia());
							sentenciaStore.setString("Par_DesFrecuencia",opeInusualesBean.getDesFrecuencia());
							sentenciaStore.setString("Par_DesOperacion",	opeInusualesBean.getDesOperacion());
							sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(opeInusualesBean.getCreditoID()));

							sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(opeInusualesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_TransaccionOpe",Utileria.convierteEntero(opeInusualesBean.getTransaccionOpe()));
							sentenciaStore.setInt("Par_NaturaOperacion",Utileria.convierteEntero(opeInusualesBean.getNaturaOperacion()));
							sentenciaStore.setDouble("Par_MontoOperacion",Utileria.convierteEntero(opeInusualesBean.getMontoOperacion()));
							sentenciaStore.setInt("Par_MonedaOperacion",Utileria.convierteEntero(opeInusualesBean.getMonedaID()));

							sentenciaStore.setString("Par_TipoPersonaSAFI", opeInusualesBean.getTipoPerSAFI());
							sentenciaStore.setString("Par_NombresPersonaInv", opeInusualesBean.getNombresPersonaInv());
							sentenciaStore.setString("Par_ApPaternoPersonaInv", opeInusualesBean.getApPaternoPersonaInv());
							sentenciaStore.setString("Par_ApMaternoPersonaInv", opeInusualesBean.getApMaternoPersonaInv());
							sentenciaStore.setString("Par_TipoListaID", Constantes.STRING_VACIO);
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);

							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID",Constantes.STRING_VACIO);
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

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
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
					);

				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}
			} catch (Exception e) {

				if (mensajeBean.getNumero() == 0) {
					mensajeBean.setNumero(999);
				}
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta  de operacionesinusuales", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
			}
			return mensajeBean;
		}
	});
	return mensaje;
}



	public OpeInusualesBean consultaPrincipal(OpeInusualesBean opeInusuales, int tipoConsulta){
		String query = "call PLDOPEINUSUALESCON(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {

				opeInusuales.getOpeInusualID(),
				Constantes.FECHA_VACIA,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"OpeInusualesDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO

				};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINUSUALESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpeInusualesBean opInt = new OpeInusualesBean();
				opInt.setOpeInusualID(resultSet.getString("OpeInusualID"));
				opInt.setCatProcedIntID(resultSet.getString("CatProcedIntID"));
				opInt.setCatMotivInuID(resultSet.getString("CatMotivInuID"));
				opInt.setFechaDeteccion(resultSet.getString("FechaDeteccion"));
				opInt.setSucursalID(resultSet.getString("SucursalID"));

				opInt.setClavePersonaInv(resultSet.getString("ClavePersonaInv"));
				opInt.setAuxClavePersonaInv(resultSet.getString("ClavePersonaInv"));
				opInt.setNomPersonaInv(resultSet.getString("NomPersonaInv"));
				opInt.setAuxNomPersonaInv(resultSet.getString("NomPersonaInv"));
				opInt.setEmpInvolucrado(resultSet.getString("EmpInvolucrado"));
				opInt.setFrecuencia(resultSet.getString("Frecuencia"));
				opInt.setDesFrecuencia(resultSet.getString("DesFrecuencia"));

				opInt.setDesOperacion(resultSet.getString("DesOperacion"));
				opInt.setEstatus(resultSet.getString("Estatus"));
				opInt.setComentarioOC(resultSet.getString("ComentarioOC"));
				opInt.setFechaCierre(resultSet.getString("FechaCierre"));
				opInt.setFecha(resultSet.getString("Fecha"));

				opInt.setCreditoID(resultSet.getString("CreditoID"));
				opInt.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				opInt.setTransaccionOpe(resultSet.getString("TransaccionOpe"));
				opInt.setNaturaOperacion(resultSet.getString("NaturaOperacion"));
				opInt.setMontoOperacion(resultSet.getString("MontoOperacion"));

				opInt.setMonedaID(resultSet.getString("MonedaID"));
				opInt.setFormaPago(resultSet.getString("FormaPago"));
				opInt.setOcupacionCli(resultSet.getString("Var_DescOcupacion"));
				opInt.setClasificacionCli(resultSet.getString("Var_Calificacion"));
				opInt.setSucursalIDCli(resultSet.getString("Var_SucursalOrigen"));
				opInt.setNombreSucursalCli(resultSet.getString("Var_NombreSucursal"));
				opInt.setNivelEstudios(resultSet.getString("Var_DesGradoEscolar"));

				opInt.setIngresoMensual(resultSet.getString("Var_IngAproxMes"));
				opInt.setIngMenSocie1(Double.valueOf(resultSet.getString("Var_Ingresos")).doubleValue());
				opInt.setEdad(resultSet.getString("Var_Edad"));
				opInt.setFechaNacimiento(resultSet.getString("Var_FechaNacimiento"));
				opInt.setEstadoCivil(resultSet.getString("Var_EstadoCivil"));
				opInt.setLocalidad(resultSet.getString("Var_Localidad"));
				opInt.setNumCredito(resultSet.getString("CreditoID"));
				opInt.setProductoCredito(resultSet.getString("Var_ProductoCredito"));
				opInt.setGrupoNoSolidadario(resultSet.getString("Var_GrupoNoSoli"));
				opInt.setTipoPerSAFI(resultSet.getString("TipoPersonaSAFI"));
			return opInt;
			}
		});
		return matches.size() > 0 ? (OpeInusualesBean) matches.get(0) : null;
	}


	public MensajeTransaccionBean actualizacion(final OpeInusualesBean opeInusualesBean, final int tipoAct ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PLDOPEINUSUALESACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_OpeInusualID",Utileria.convierteEntero(opeInusualesBean.getOpeInusualID()));
								sentenciaStore.setString("Par_Estatus",opeInusualesBean.getEstatus());
								sentenciaStore.setString("Par_ComentarioOC",opeInusualesBean.getComentarioOC());
								sentenciaStore.setInt("Par_ClavePersonaInv",Utileria.convierteEntero(opeInusualesBean.getClavePersonaInv()));
								sentenciaStore.setString("Par_NomPersonaInv",opeInusualesBean.getNomPersonaInv());
								sentenciaStore.setInt("Par_Var_SucOrigen",Utileria.convierteEntero(opeInusualesBean.getSucursalID()));
								sentenciaStore.setInt("Par_TipoActulizacion",tipoAct);
								sentenciaStore.setInt("Par_FolioInterno",Utileria.convierteEntero(opeInusualesBean.getFolioInterno()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());


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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();

					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de operaciones inusuales", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean actualizacion(final OpeInusualesBean opeInusualesBean,  final int  tipoAct, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PLDOPEINUSUALESACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_OpeInusualID",Utileria.convierteEntero(opeInusualesBean.getOpeInusualID()));
								sentenciaStore.setString("Par_Estatus",opeInusualesBean.getEstatus());
								sentenciaStore.setString("Par_ComentarioOC",opeInusualesBean.getComentarioOC());
								sentenciaStore.setInt("Par_ClavePersonaInv",Utileria.convierteEntero(opeInusualesBean.getClavePersonaInv()));
								sentenciaStore.setString("Par_NomPersonaInv",opeInusualesBean.getNomPersonaInv());
								sentenciaStore.setInt("Par_Var_SucOrigen",Utileria.convierteEntero(opeInusualesBean.getSucursalID()));
								sentenciaStore.setInt("Par_TipoActulizacion",tipoAct);
								sentenciaStore.setInt("Par_FolioInterno",Utileria.convierteEntero(opeInusualesBean.getFolioInterno()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();

					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar operacion inusual", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Lista de operaciones inusuales */

	public List listaAlfanumerica(OpeInusualesBean opInusualesBean, int tipoLista){
		String query = "call PLDOPEINUSUALESLIS(?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
					opInusualesBean.getNomPersonaInv(),
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"opeInusualesDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINUSUALESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpeInusualesBean opInusBean = new OpeInusualesBean();
				opInusBean.setOpeInusualID(resultSet.getString(1));
				opInusBean.setNomPersonaInv(resultSet.getString(2));
				opInusBean.setFecha(resultSet.getString(3));
				return opInusBean;
			}
		});
		return matches;
		}

	//consulta para generar el nombre del archivo para el reporte
	public OpeInusualesBean consultaNombreArchivo(OpeInusualesBean opeInusuales, int tipoConsulta){

		List matches=null;
		try{
			String query = "call PLDOPEINUSUALESCON(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					opeInusuales.getFecha(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"OpeInusualesDAO.consultaNombreArchivo",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINUSUALESCON(" + Arrays.toString(parametros) + ")");
			matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OpeInusualesBean opInt = new OpeInusualesBean();
					opInt.setNombreArchivo(resultSet.getString("nombreArchivo"));
				return opInt;
				}
			});

		}catch(Exception e){
			e.printStackTrace();

			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de nombre de archivos", e);
		}
		return matches.size() > 0 ? (OpeInusualesBean) matches.get(0) : null;
	}




	/* Actualización Operaciones Inusuales para la el reporte TXT */
	public MensajeTransaccionBean actPLDReporte( final int tipoAct,final int quitarFolioInterno, final OpeInusualesBean opeInusuales, final List listaDatosGrid, final int listaReporte) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		// Se obtiene el tipo de institucion financiera
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
		final String tipoInstitucion = parametrosSisBean.getNombreCortoInst();

		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				String nombreArchivo = Constantes.STRING_VACIO;
				String rutaArchivo = Constantes.STRING_VACIO;
				List ListaOperacionParaArchivo = null;

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					OpeInusualesBean opeInusualesBean = new OpeInusualesBean();
						//------- quitamos todos los folios internos de los archivos que estaban marcados a enviar ala CNBV---------
						opeInusualesBean.setOpeInusualID(Constantes.STRING_VACIO);
						opeInusualesBean.setEstatus(Constantes.STRING_VACIO);
						opeInusualesBean.setComentarioOC(Constantes.STRING_VACIO);
						opeInusualesBean.setClavePersonaInv(Constantes.STRING_VACIO);
						opeInusualesBean.setNomPersonaInv(Constantes.STRING_VACIO);
						opeInusualesBean.setSucursalID(Constantes.STRING_VACIO);
						opeInusualesBean.setFolioInterno(Constantes.STRING_VACIO);

						mensajeBean = actualizacion(opeInusualesBean, quitarFolioInterno, parametrosAuditoriaBean.getNumeroTransaccion() );
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

						//----------------- ingresamos los folios de las operaciones a enviar a la CNVB-----------------------
					for(int i=0; i<listaDatosGrid.size(); i++){
						opeInusualesBean = new OpeInusualesBean();
						opeInusualesBean = (OpeInusualesBean)listaDatosGrid.get(i);
						mensajeBean = actualizacion(opeInusualesBean, tipoAct, parametrosAuditoriaBean.getNumeroTransaccion());

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					ListaOperacionParaArchivo = consultaDatosReporteTXT(listaReporte);
					String[] columnas = null;
					/* Genera el archivo con los campos de acuerdo al tipo de institucion */
					if(tipoInstitucion.equals("scap")||tipoInstitucion.equals("sofipo")){
						columnas = new String[]{
								 "tipoReporte",			"periodoCorresponde",	 "folio",			"claveOrgSupervisor",	"claveEntCasFim",
								 "localidadSuc",		"sucursalCP",			 "tipoOperacionID",	"instrumentMonID",		"cuentaAhoID",
								 "monto",				"claveMoneda",	 		 "fechaOpe",		"fechaDeteccion",		"nacionalidad",
								 "tipoPersona",			"razonSocial",			 "nombre",			"apellidoPat",			"apellidoMat",
								 "RFC",					"CURP",					 "fechaNac",		"domicilio",			"colonia",
								 "localidad",			"telefono",				 "actEconomica",	"nomApoderado",			"apPatApoderado",
								 "apMatApoderado",		"RFCApoderado",			 "CURPApoderado",	"consecutivoCta",		"ctaRelacionadoID",
								 "claveCasfimRelacionado","nombreRelacionado",	 "apPatRelacionado","apMatRelacionado",		"desOperacion",
								 "razones"};
					}else{
						columnas = new String[]{
								 "tipoReporte",			"periodoCorresponde",	 "folio",			"claveOrgSupervisor",	"claveEntCasFim",
								 "localidadSuc",		"sucursalCP",			 "tipoOperacionID",	"instrumentMonID",		"cuentaAhoID",
								 "monto",				"claveMoneda",	 		 "fechaOpe",		"fechaDeteccion",		"nacionalidad",
								 "tipoPersona",			"razonSocial",			 "nombre",			"apellidoPat",			"apellidoMat",
								 "RFC",					"CURP",					 "fechaNac",		"domicilio",			"colonia",
								 "localidad",			"telefono",				 "actEconomica",	"consecutivoCta",		"ctaRelacionadoID",
								 "claveCasfimRelacionado","nombreRelacionado",	 "apPatRelacionado","apMatRelacionado",		"desOperacion",
								 "razones"};
					}

					//--------------- Creamos el archivo txt.-------
					nombreArchivo = opeInusuales.getNombreArchivo();
					rutaArchivo=opeInusuales.getRutaArchivosPLD();
					Archivos archivoTXT= new Archivos();
					nombreArchivo  = archivoTXT.EscribeArchivoTexto(ListaOperacionParaArchivo, columnas, PLDCNBVopeInuBean.class.getName(),rutaArchivo, nombreArchivo , "txt", ";");

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();

					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de reporte de PLD", e);
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



	//grid para la pantalla de reporte (TXT)
	public List listaGrid(int tipoLista){

		List listaGrid=null;
		try{
			String query = "call PLDOPEINUSUALESLIS(?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {
						Constantes.STRING_VACIO,
						Constantes.STRING_VACIO,
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"opeInusualesDAO.listaAlfanumerica",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
					};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINUSUALESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					OpeInusualesBean opInusBean = new OpeInusualesBean();

					opInusBean.setOpeInusualID(resultSet.getString("OpeInusualID"));
					opInusBean.setFechaDeteccion(resultSet.getString("FechaDeteccion"));
					opInusBean.setDiasRestantes(resultSet.getString("DiasRestantes"));
					opInusBean.setFechaCierre(resultSet.getString("FechaCierre"));
					opInusBean.setClaveRegistraDescri(resultSet.getString("ClaveRegistraDescri"));

					opInusBean.setDesCorta(resultSet.getString("DesCorta"));
					opInusBean.setDesOperacion(resultSet.getString("DesOperacion"));
					opInusBean.setComentarioOC(resultSet.getString("ComentarioOC"));
					opInusBean.setFolioInterno(resultSet.getString("FolioInterno"));

				return opInusBean;
				}
			});
			listaGrid=matches;

		}catch(Exception e){
			e.printStackTrace();

			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid", e);
		}
		return listaGrid;

	}
	//consulta datos para generar el txt
		public List consultaDatosReporteTXT(int tipoLista){
			List matches=null;
			try{					
				String query = "call PLDOPEINUSUALESLIS(?,?,?,?,?,	?,?,?,?,?);";
				Object[] parametros = {
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							tipoLista,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"opeInusualesDAO.listaAlfanumerica",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()

						};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINUSUALESLIS(" + Arrays.toString(parametros) + ")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						PLDCNBVopeInuBean opInt = new PLDCNBVopeInuBean();

						opInt.setTipoReporte(resultSet.getString("TipoDeReporte"));
						opInt.setPeriodoCorresponde(resultSet.getString("Periodo"));
						opInt.setFolio(resultSet.getString("Folio"));
						opInt.setClaveOrgSupervisor(resultSet.getString("OrganoSup"));
						opInt.setClaveEntCasFim(resultSet.getString("ClaveCasfim"));

						opInt.setLocalidadSuc(resultSet.getString("Localidad"));// localidad de la sucursal
						opInt.setSucursalCP(resultSet.getString("SucursalCP"));
						opInt.setTipoOperacionID(resultSet.getString("TipoOperacion"));
						opInt.setInstrumentMonID(resultSet.getString("InstrumentoMon"));
						opInt.setCuentaAhoID(resultSet.getString("NumCuenta"));//

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
						opInt.setConsecutivoCta(resultSet.getString("ConsecutivoCuenta"));//
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

		public MensajeTransaccionBean actualiza(final PLDCNBVopeInuBean pldCNBVopeInuBean, final int tipoAct ) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PLDCNBVOPEINUACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_OpeInusualID",pldCNBVopeInuBean.getFolioSITI());
									sentenciaStore.setString("Par_OpeInusualID",pldCNBVopeInuBean.getUsuarioSITI());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());


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
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						e.printStackTrace();

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar PLD", e);
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		/**
		 * Lista y actualiza las Operaciones Inusuales para mostrarse en el reporte en Excel.
		 * @param tipoAct
		 * @param quitarFolioInterno
		 * @param opeInusuales
		 * @param listaDatosGrid
		 * @param listaReporte
		 * @return
		 */
		public List generaReporteExcel( final int tipoAct,final int quitarFolioInterno, final ReportesSITIBean opeInusuales, final List listaDatosGrid, final int listaReporte) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			List ListaOperacionParaArchivo = null;
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {

					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						ReportesSITIBean opeInusualesBean = new ReportesSITIBean();
						//------- quitamos todos los folios internos de los archivos que estaban marcados a enviar ala CNBV---------
						opeInusualesBean.setOpeInusualID(Constantes.STRING_VACIO);
						opeInusualesBean.setEstatus(Constantes.STRING_VACIO);
						opeInusualesBean.setComentarioOC(Constantes.STRING_VACIO);
						opeInusualesBean.setClavePersonaInv(Constantes.STRING_VACIO);
						opeInusualesBean.setNomPersonaInv(Constantes.STRING_VACIO);
						opeInusualesBean.setSucursalID(Constantes.STRING_VACIO);
						opeInusualesBean.setFolioInterno(Constantes.STRING_VACIO);

						mensajeBean = actualizacion(opeInusualesBean, quitarFolioInterno, parametrosAuditoriaBean.getNumeroTransaccion());
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

						//----------------- ingresamos los folios de las operaciones a enviar a la CNVB-----------------------
						for(int i=0; i<listaDatosGrid.size(); i++){
							opeInusualesBean = new ReportesSITIBean();
							opeInusualesBean = (ReportesSITIBean)listaDatosGrid.get(i);
							mensajeBean = actualizacion(opeInusualesBean, tipoAct, parametrosAuditoriaBean.getNumeroTransaccion());

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}


					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						e.printStackTrace();

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de reporte Operaciones Inusuales PLD: ", e);
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}

					return mensajeBean;
				}
			});

			if(mensaje.getNumero()==0){
				ListaOperacionParaArchivo = consultaDatosReporteExcel(opeInusuales,listaReporte);
			} else {
				ListaOperacionParaArchivo = null;
			}
			return ListaOperacionParaArchivo;
		}


		public MensajeTransaccionBean actualizacion(final ReportesSITIBean opeInusualesBean,  final int  tipoAct, final long numTransaccion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call PLDOPEINUSUALESACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setInt("Par_OpeInusualID",Utileria.convierteEntero(opeInusualesBean.getOpeInusualID()));
										sentenciaStore.setString("Par_Estatus",opeInusualesBean.getEstatus());
										sentenciaStore.setString("Par_ComentarioOC",opeInusualesBean.getComentarioOC());
										sentenciaStore.setInt("Par_ClavePersonaInv",Utileria.convierteEntero(opeInusualesBean.getClavePersonaInv()));
										sentenciaStore.setString("Par_NomPersonaInv",opeInusualesBean.getNomPersonaInv());
										sentenciaStore.setInt("Par_Var_SucOrigen",Utileria.convierteEntero(opeInusualesBean.getSucursalID()));
										sentenciaStore.setInt("Par_TipoActulizacion",tipoAct);
										sentenciaStore.setInt("Par_FolioInterno",Utileria.convierteEntero(opeInusualesBean.getFolioInterno()));

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
											mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
										}

										return mensajeTransaccion;
									}
								}
								);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						e.printStackTrace();

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar operacion inusual", e);
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		//consulta datos para generar el txt
		public List consultaDatosReporteExcel(final ReportesSITIBean opeInusualesBean,int tipoLista){
			List matches=null;
			try{					
				String query = "call PLDOPEINUSUALESLIS(?,?,?,?,?,	?,?,?,?,?);";
				Object[] parametros = {
						Constantes.STRING_VACIO,
						opeInusualesBean.getOperaciones(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"opeInusualesDAO.listaAlfanumerica",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()

				};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDOPEINUSUALESLIS(" + Arrays.toString(parametros) + ")");
				matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ReportesSITIBean opInt = new ReportesSITIBean();

						opInt.setTipoReporte(resultSet.getString("TipoDeReporte"));
						opInt.setPeriodoReporte(resultSet.getString("Periodo"));
						opInt.setFolio(resultSet.getString("Folio"));
						opInt.setClaveOrgSupervisor(resultSet.getString("OrganoSup"));
						opInt.setClaveEntCasFim(resultSet.getString("ClaveCasfim"));

						opInt.setLocalidadSuc(resultSet.getString("Localidad"));// localidad de la sucursal
						opInt.setSucursalID(resultSet.getString("SucursalCP"));
						opInt.setTipoOperacionID(resultSet.getString("TipoOperacion"));
						opInt.setInstrumentMonID(resultSet.getString("InstrumentoMon"));
						opInt.setCuentaAhoID(resultSet.getString("NumCuenta"));//

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
						opInt.setCtaRelacionadoID(resultSet.getString("ConsecutivoCuenta"));//
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

	public List<OpeInusualesBean> listaReporteOpInu(OpeInusualesBean operacionesInusualesBean) {
		transaccionDAO.generaNumeroTransaccion();
		List<OpeInusualesBean> ListaResultado = null;
		try {
			String query = "CALL PLDOPEINUSUALESREP(" 
					+ "?,?,?,?,?," 
					+ "?,?,?,?,?,"
					+ "?,?,?,?,?);";
			Object[] parametros = {
					1,
					operacionesInusualesBean.getFechaInicio(),
					operacionesInusualesBean.getFechaFinal(),
					operacionesInusualesBean.getEstatus(),
					operacionesInusualesBean.getPeriodo(),

					operacionesInusualesBean.getOperaciones(),
					operacionesInusualesBean.getClienteID(),
					Utileria.convierteEntero(operacionesInusualesBean.getUsuarioServicioID()),
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),

					"OpeInusalesBean.listaReporteOpInu",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion() };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL PLDOPEINUSUALESREP(  " + Arrays.toString(parametros) + ");");
			List<OpeInusualesBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OpeInusualesBean bean = new OpeInusualesBean();

					bean.setFecha(resultSet.getString("Fecha"));
					bean.setOpeInusualID(resultSet.getString("OpeInusualID"));
					bean.setCatProcedIntID(resultSet.getString("CatProcedIntID"));
					bean.setDesc_CatProcedInt(resultSet.getString("Desc_CatProcedInt"));
					bean.setCatMotivInuID(resultSet.getString("CatMotivInuID"));
					bean.setDesc_CatMotivInu(resultSet.getString("Desc_CatMotivInu"));
					bean.setFechaDeteccion(resultSet.getString("FechaDeteccion"));
					bean.setSucursalID(resultSet.getString("SucursalID"));
					bean.setClavePersonaInv(resultSet.getString("ClavePersonaInv"));
					bean.setNomPersonaInv(resultSet.getString("NomPersonaInv"));
					bean.setFrecuencia(resultSet.getString("Frecuencia"));
					bean.setDesFrecuencia(resultSet.getString("DesFrecuencia"));
					bean.setDesOperacion(resultSet.getString("DesOperacion"));
					bean.setEstatus(resultSet.getString("Estatus"));
					bean.setCreditoID(resultSet.getString("CreditoID"));
					bean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					bean.setNaturaOperacion(resultSet.getString("NaturaOperacion"));
					bean.setMontoOperacion(resultSet.getString("MontoOperacion"));
					bean.setMonedaID(resultSet.getString("MonedaID"));
					bean.setEqCNBVUIF(resultSet.getString("EqCNBVUIF"));
					bean.setFolioInterno(resultSet.getString("FolioInterno"));
					bean.setTipoOpeCNBV(resultSet.getString("TipoOpeCNBV"));
					bean.setFormaPago(resultSet.getString("FormaPago"));
					bean.setTipoPersonaSAFI(resultSet.getString("TipoPersonaSAFI"));
					bean.setFechaAlta(resultSet.getString("FechaAlta"));
					bean.setActividadBancoMX(resultSet.getString("ActividadBancoMX"));
					bean.setActividadBMXDesc(resultSet.getString("ActividadBMXDesc"));
					bean.setNivelRiesgo(resultSet.getString("NivelRiesgo"));

					return bean;
				}
			});
			ListaResultado = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en reporte de Operaciones Inusuales: ", e);
		}
		return ListaResultado;
	}

	public List<OpeInusualesBean> listaReporteOpFrac(OpeInusualesBean operacionesInusualesBean) {
		transaccionDAO.generaNumeroTransaccion();
		List<OpeInusualesBean> ListaResultado = null;
		try {
			String query = "CALL PLDOPEINUSUALESREP(" 
					+ "?,?,?,?,?," 
					+ "?,?,?,?,?,"
					+ "?,?,?,?,?);";
			Object[] parametros = {
					2,
					operacionesInusualesBean.getFechaInicio(),
					operacionesInusualesBean.getFechaFinal(),
					operacionesInusualesBean.getEstatus(),
					operacionesInusualesBean.getPeriodo(),
					
					operacionesInusualesBean.getOperaciones(),
					Utileria.convierteEntero(operacionesInusualesBean.getClienteID()),
					Utileria.convierteEntero(operacionesInusualesBean.getUsuarioServicioID()),
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),

					"OpeInusalesBean.listaReporteOpInu",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion() };

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL PLDOPEINUSUALESREP(  " + Arrays.toString(parametros) + ");");
			List<OpeInusualesBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OpeInusualesBean bean = new OpeInusualesBean();
					bean.setClienteID(resultSet.getString("ClienteID"));
					bean.setNomPersonaInv(resultSet.getString("NombreCliente"));
					bean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					bean.setTransaccionOpe(resultSet.getString("NumTransaccion"));
					bean.setDescripcionMov(resultSet.getString("DescripcionMov"));
					bean.setMontoOperacion(resultSet.getString("Monto"));
					bean.setTotalMonto(resultSet.getString("MontoTotal"));
					bean.setFecha(resultSet.getString("FechaMov"));
					bean.setTipoOperacion(resultSet.getString("TipoDetalle"));
					return bean;
				}
			});
			ListaResultado = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en reporte de Operaciones Fraccionadas: ", e);
		}
		return ListaResultado;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}


	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

}