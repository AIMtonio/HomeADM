package cliente.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import ventanilla.bean.IngresosOperacionesBean;
import cliente.bean.ApoyoEscolarSolBean;
import cliente.bean.ReporteApoyoEscolarSolBean;
import general.bean.ParametrosSesionBean;

public class ApoyoEscolarSolDAO extends BaseDAO {
	ParametrosSesionBean parametrosSesionBean;

	public ApoyoEscolarSolDAO(){
		super();
	}



	/*=============================== METODOS ==================================*/



	/* Consuta Principal (por clienteID), obtiene las solicitudes de apoyo escolar de un cliente*/
	public ApoyoEscolarSolBean consultaPrincipal(ApoyoEscolarSolBean apoyoEscolarSol,int tipoConsulta) {

			ApoyoEscolarSolBean apoyoEscolarSolBean= new ApoyoEscolarSolBean();

		try{

			/*Query con el Store Procedure */
			String query = "call APOYOESCOLARSOLCON(?,?,?,?,?, ?,?,?,?,?);";

			Object[] parametros = {Utileria.convierteEntero(apoyoEscolarSol.getClienteID()),
								   Utileria.convierteEntero(apoyoEscolarSol.getApoyoEscSolID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,		//	aud_empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO };	//	numTransaccion

			/*Registra el  inf. del log */
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APOYOESCOLARSOLCON(" + Arrays.toString(parametros) + ")");


			/*E]ecuta el query y setea los valores al bean para obtener los datos de la consulta*/
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
						/*bean para setear los valores obtenidos de la ejecucion de la consulta */
						ApoyoEscolarSolBean apoyoEscolarSolBean= new ApoyoEscolarSolBean();
								apoyoEscolarSolBean.setApoyoEscSolID(Utileria.completaCerosIzquierda(resultSet.getString("ApoyoEscSolID"),ApoyoEscolarSolBean.LONGITUD_ID));
								apoyoEscolarSolBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),ApoyoEscolarSolBean.LONGITUD_ID));
								apoyoEscolarSolBean.setApoyoEscCicloID(resultSet.getString("ApoyoEscCicloID"));
								apoyoEscolarSolBean.setGradoEscolar(resultSet.getString("GradoEscolar"));
								apoyoEscolarSolBean.setCicloEscolar(resultSet.getString("CicloEscolar"));
								apoyoEscolarSolBean.setPromedioEscolar(resultSet.getString("PromedioEscolar"));
								apoyoEscolarSolBean.setNombreEscuela(resultSet.getString("NombreEscuela"));
								apoyoEscolarSolBean.setDireccionEscuela(resultSet.getString("DireccionEscuela"));
								apoyoEscolarSolBean.setEdadCliente(resultSet.getString("EdadCliente"));
								apoyoEscolarSolBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
								apoyoEscolarSolBean.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
								apoyoEscolarSolBean.setFechaPago(resultSet.getString("FechaPago"));
								apoyoEscolarSolBean.setEstatus(resultSet.getString("Estatus"));
								apoyoEscolarSolBean.setUsuarioRegistra(resultSet.getString("UsuarioRegistra"));
								apoyoEscolarSolBean.setUsuarioAutoriza(resultSet.getString("UsuarioAutoriza"));
								apoyoEscolarSolBean.setMonto(resultSet.getString("Monto"));
								apoyoEscolarSolBean.setTransaccionPago(resultSet.getString("TransaccionPago"));
								apoyoEscolarSolBean.setPolizaID(resultSet.getString("PolizaID"));
								apoyoEscolarSolBean.setCajaID(resultSet.getString("CajaID"));
								apoyoEscolarSolBean.setSucursalCajaID(resultSet.getString("SucursalCajaID"));
								apoyoEscolarSolBean.setSucursalRegistroID(resultSet.getString("SucursalRegistroID"));
								apoyoEscolarSolBean.setComentario(resultSet.getString("Comentario"));
								apoyoEscolarSolBean.setDesCicloEscolar(resultSet.getString("Descripcion"));

								return apoyoEscolarSolBean;
						}// trows ecexeption
			});//lista



			apoyoEscolarSolBean= matches.size() > 0 ? (ApoyoEscolarSolBean) matches.get(0) : null;

			/*Maneja la exception y registra el log de error */
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal Solicitud de Apoyo Escolar", e);
		}


		/*Retorna un objeto cargado de datos */
		return apoyoEscolarSolBean;

	}// consultaPrincipal

	// metodo que se utiliza para validar pago de apoyo escolar en ventanilla
	public String consultaEstatusSoliApoyoEsc(ApoyoEscolarSolBean apoyoEscolarSolBean, int tipoConsulta) {
		String estatusSolicitud = "0";

		try{
			String query = "call APOYOESCOLARSOLCON(?,?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	Constantes.ENTERO_CERO,
									apoyoEscolarSolBean.getApoyoEscSolID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ApoyoEscolarSolDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APOYOESCOLARSOLCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String estatus = new String();

					estatus=resultSet.getString("Estatus");
						return estatus;
				}
			});
		estatusSolicitud= matches.size() > 0 ? (String) matches.get(0) : "0";
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Estatus de la Solicitud de Apoyo Escolar", e);
		}
		return estatusSolicitud;
	}









	/* da de alta una solicitud de apoyo escolar */
	public MensajeTransaccionBean alta(final ApoyoEscolarSolBean apoyoEscolarSolBean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call APOYOESCOLARSOLALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(apoyoEscolarSolBean.getClienteID()));
						sentenciaStore.setInt("Par_EdadCliente",Utileria.convierteEntero(apoyoEscolarSolBean.getEdadCliente()));
						sentenciaStore.setInt("Par_ApoyoEscCicloID", Utileria.convierteEntero(apoyoEscolarSolBean.getApoyoEscCicloID()));
						sentenciaStore.setInt("Par_GradoEscolar",Utileria.convierteEntero(apoyoEscolarSolBean.getGradoEscolar()));
						sentenciaStore.setDouble("Par_PromedioEscolar",Utileria.convierteDoble(apoyoEscolarSolBean.getPromedioEscolar()));
						sentenciaStore.setString("Par_CicloEscolar",apoyoEscolarSolBean.getCicloEscolar());
						sentenciaStore.setString("Par_NombreEscuela",apoyoEscolarSolBean.getNombreEscuela());
						sentenciaStore.setString("Par_DireccionEscuela",apoyoEscolarSolBean.getDireccionEscuela());
						sentenciaStore.setInt("Par_UsuarioRegistra", Utileria.convierteEntero(apoyoEscolarSolBean.getUsuarioRegistra()));
						sentenciaStore.setInt("Par_SucursalRegistroID", Utileria.convierteEntero(apoyoEscolarSolBean.getSucursalRegistroID()));

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APOYOESCOLARSOLALT(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta solicitud de apoyo escolar", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});



		return mensaje;
	}// fin de alta




/* Modificacion de todos los campos de una solicitud de apoyo escolar*/
public MensajeTransaccionBean modificar(final ApoyoEscolarSolBean apoyoEscolarSolBean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

	transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

				/* Query con el Store Procedure */
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call APOYOESCOLARSOLMOD(" +
														"?,?,?,?,?, ?,?,?,?,?," +
														"?,?,?,?,?, ?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(apoyoEscolarSolBean.getClienteID()));
							sentenciaStore.setInt("Par_ApoyoEscSolID", Utileria.convierteEntero(apoyoEscolarSolBean.getApoyoEscSolID()));
							sentenciaStore.setInt("Par_EdadCliente",Utileria.convierteEntero(apoyoEscolarSolBean.getEdadCliente()));
							sentenciaStore.setInt("Par_ApoyoEscCicloID", Utileria.convierteEntero(apoyoEscolarSolBean.getApoyoEscCicloID()));
							sentenciaStore.setInt("Par_GradoEscolar",Utileria.convierteEntero(apoyoEscolarSolBean.getGradoEscolar()));
							sentenciaStore.setDouble("Par_PromedioEscolar",Utileria.convierteDoble(apoyoEscolarSolBean.getPromedioEscolar()));
							sentenciaStore.setString("Par_CicloEscolar",apoyoEscolarSolBean.getCicloEscolar());
							sentenciaStore.setString("Par_NombreEscuela",apoyoEscolarSolBean.getNombreEscuela());
							sentenciaStore.setString("Par_DireccionEscuela",apoyoEscolarSolBean.getDireccionEscuela());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APOYOESCOLARSOLMOD(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificación de solicitud de apoyo escolar", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de modifica



/* Autoriza o rechaza una solicitud de apoyo escolar*/
public MensajeTransaccionBean actualiza(final ApoyoEscolarSolBean apoyoEscolarSolBean, final int tipoActualizacion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call APOYOESCOLARSOLACT(" +
												"?,?,?,?,?, ?,?,?,?,?," +
												"?,?,?,?,?, ?,?,?,?,?, ? );";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(apoyoEscolarSolBean.getClienteID()));
								sentenciaStore.setInt("Par_ApoyoEscSolID", Utileria.convierteEntero(apoyoEscolarSolBean.getApoyoEscSolID()));
								sentenciaStore.setInt("Par_UsuarioAutoriza",Utileria.convierteEntero(apoyoEscolarSolBean.getUsuarioAutoriza()));
								sentenciaStore.setString("Par_Estatus",apoyoEscolarSolBean.getEstatus());
								sentenciaStore.setString("Par_Comentario",apoyoEscolarSolBean.getComentario());

								sentenciaStore.setLong("Par_TransaccionPago", Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Par_PolizaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_CajaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_SucursalCajaID",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_RecibePago",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

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
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualización de solicitud de apoyo escolar", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de actualiza

		/* Lista de Solicitude por cliente para grid*/
		public List listaPrincipal(ApoyoEscolarSolBean apoyoEscolarSolBean, int tipoLista) {
			String query = "call APOYOESCOLARSOLLIS(?,?,?,?,?,  ?,?,?,?,?, ?);";
			Object[] parametros = {	Utileria.convierteEntero(apoyoEscolarSolBean.getClienteID()),
									Utileria.convierteEntero(apoyoEscolarSolBean.getApoyoEscSolID()),
									Constantes.STRING_VACIO,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APOYOESCOLARSOLLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ApoyoEscolarSolBean solicitud = new ApoyoEscolarSolBean();

					solicitud.setClienteID(Utileria.completaCerosIzquierda(resultSet.getInt("ClienteID"),ApoyoEscolarSolBean.LONGITUD_ID));
					solicitud.setApoyoEscSolID(resultSet.getString("ApoyoEscSolID"));
					solicitud.setEdadCliente(resultSet.getString("EdadCliente"));
					solicitud.setApoyoEscCicloID(resultSet.getString("ApoyoEscCicloID"));
					solicitud.setGradoEscolar(resultSet.getString("GradoEscolar"));
					solicitud.setCicloEscolar(resultSet.getString("CicloEscolar"));
					solicitud.setPromedioEscolar(resultSet.getString("PromedioEscolar"));
					solicitud.setMonto(resultSet.getString("Monto"));
					solicitud.setEstatus(resultSet.getString("Estatus"));
					solicitud.setFechaRegistro(resultSet.getString("FechaRegistro"));
					solicitud.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
					solicitud.setFechaPago(resultSet.getString("FechaPago"));
					solicitud.setUsuarioRegistra(resultSet.getString("UsuarioRegistra"));

					return solicitud;
				}
			});
			return matches;
		} // fin de lista


		/* Lista de Solicitudes por ID de solicitud para lista de ayuda */
		public List listaPorSolicitud(ApoyoEscolarSolBean apoyoEscolarSolBean, int tipoLista) {

			String query = "call APOYOESCOLARSOLLIS(?,?,?,?,?,  ?,?,?,?,?, ?);";
			Object[] parametros = {Utileria.convierteEntero(apoyoEscolarSolBean.getClienteID()),
								   apoyoEscolarSolBean.getApoyoEscSolID(),
									Constantes.STRING_VACIO,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APOYOESCOLARSOLLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ApoyoEscolarSolBean solicitud = new ApoyoEscolarSolBean();
					solicitud.setApoyoEscSolID(Utileria.completaCerosIzquierda(resultSet.getString("ApoyoEscSolID"),ApoyoEscolarSolBean.LONGITUD_ID));
					solicitud.setNombreCompleto(resultSet.getString("NombreCompleto"));

					return solicitud;
				}
			});
			return matches;
		} // fin de lista

		/*Lista de Clientes con Solicitudes Autorizadas */
		public List listaClientesSolAut(ApoyoEscolarSolBean apoyoEscolarSolBean, int tipoLista) {

			String query = "call APOYOESCOLARSOLLIS(?,?,?,?,?,  ?,?,?,?,?, ?);";
			Object[] parametros = {
									Utileria.convierteEntero(apoyoEscolarSolBean.getClienteID()),
									apoyoEscolarSolBean.getApoyoEscSolID(),
									apoyoEscolarSolBean.getNombreCompleto(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APOYOESCOLARSOLLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ApoyoEscolarSolBean solicitud = new ApoyoEscolarSolBean();

					solicitud.setApoyoEscSolID(resultSet.getString("ClienteID"));
					solicitud.setNombreCompleto(resultSet.getString("NombreCompleto"));
					solicitud.setDireccionIP(resultSet.getString("Direccion"));

					return solicitud;
				}
			});
			return matches;
		} // fin de lista

		// ----Lista Para Combo
	public List solicitudesListaCombo(ApoyoEscolarSolBean apoyoEscolarSolBean, int tipoLista) {
		loggerSAFI.debug("Lista Combo: "+tipoLista+ " Numero de Cte: "+ apoyoEscolarSolBean.getClienteID());
		String query = "call APOYOESCOLARSOLLIS(?,?,?,?,?,  ?,?,?,?,?, ?);";
		Object[] parametros = {
								Utileria.convierteEntero(apoyoEscolarSolBean.getClienteID()),
								Utileria.convierteEntero(apoyoEscolarSolBean.getApoyoEscSolID()),
								apoyoEscolarSolBean.getNombreCompleto(),
								tipoLista,


								Constantes.ENTERO_CERO,		//	aud_empresaID
								Constantes.ENTERO_CERO,		//	aud_usuario
								Constantes.FECHA_VACIA,		//	fechaActual
								Constantes.STRING_VACIO,	// 	direccionIP
								Constantes.STRING_VACIO, 	//	programaID
								Constantes.ENTERO_CERO,		// 	sucursal
								Constantes.ENTERO_CERO };	//	numTransaccion

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APOYOESCOLARSOLLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ApoyoEscolarSolBean solicitud = new ApoyoEscolarSolBean();

				solicitud.setApoyoEscSolID(resultSet.getString("ApoyoEscSolID"));
				solicitud.setDescripcionSolcitud(resultSet.getString("Descripcion"));

				return solicitud;
			}
		});
		return matches;
	} // fin de lista



	/* metodo de lista para obtener los datos para el reporte */
  public List listaReporte(final ReporteApoyoEscolarSolBean solicitudAEBean, int tipoReporte){
		List ListaResultado=null;

		try{
		String query = "CALL APOYOESCOLARSOLREP(?,?,?,?,?,  ?,?,?,?,?, ?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(solicitudAEBean.getFechaInicio()),
							Utileria.convierteFecha(solicitudAEBean.getFechaFin()),
							solicitudAEBean.getEstatus(),
							Utileria.convierteEntero(solicitudAEBean.getSucursalRegistroID()),
							tipoReporte,

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};


		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL APOYOESCOLARSOLREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReporteApoyoEscolarSolBean apoyoEscolarBean= new ReporteApoyoEscolarSolBean();

				apoyoEscolarBean.setApoyoEscSolID(resultSet.getString("ApoyoEscSolID"));
				apoyoEscolarBean.setClienteID(resultSet.getString("ClienteID"));
				apoyoEscolarBean.setSucursalRegistroID(resultSet.getString("SucursalRegistroID"));
				apoyoEscolarBean.setNombreSucurs(resultSet.getString("NombreSucurs"));
				apoyoEscolarBean.setNombreCompleto(resultSet.getString("NombreCompleto"));

				apoyoEscolarBean.setMonto(resultSet.getString("Monto"));
				apoyoEscolarBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				apoyoEscolarBean.setUsuarioRegistra(resultSet.getString("UsuarioRegistra"));
				apoyoEscolarBean.setNivelEscolar(resultSet.getString("NivelEscolar"));

				apoyoEscolarBean.setGradoEscolar(resultSet.getString("GradoEscolar"));
				apoyoEscolarBean.setPromedioEscolar(resultSet.getString("PromedioEscolar"));
				apoyoEscolarBean.setEdadCliente(resultSet.getString("EdadCliente"));
				apoyoEscolarBean.setCicloEscolar(resultSet.getString("CicloEscolar"));
				apoyoEscolarBean.setEstatusDes(resultSet.getString("EstatusDes"));
				apoyoEscolarBean.setHoraEmision(resultSet.getString("HoraEmision"));

				return apoyoEscolarBean ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Apoyo Escolar", e);
		}
		return ListaResultado;
	}// fin lista report

	/**
	 * Método para realizar el Pago de Apoyo Escolar
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean pagoApoyoEscolar(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PAGOAPOYOESCOLARPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ApoyoEscSolID", Utileria.convierteEntero(ingresosOperacionesBean.getApoyoEscSolID()));
							sentenciaStore.setLong("Par_TransaccionPago", numeroTransaccion);
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_SucursalCajaID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setString("Par_PersonaRecibe", ingresosOperacionesBean.getNombreCliente());
							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de Apoyo Escolar", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de Apoyo Escolar", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}



	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}



}// fin clase
