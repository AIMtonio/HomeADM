package guardaValores.dao;

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

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import guardaValores.bean.ParamGuardaValoresBean;
import herramientas.Constantes;
import herramientas.Utileria;

public class ParamGuardaValoresDAO extends BaseDAO {

	public ParamGuardaValoresDAO(){
		super();
	}

	// Proceso de Alta de Parametros de Guarda Valores
	public MensajeTransaccionBean altaParametros(final ParamGuardaValoresBean paramGuardaValoresBean, final List listaFacultados, final List listaDocumentos) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String paramGuardaValoresID = "";
				try {

					mensajeBean = altaParamGuardaValores(paramGuardaValoresBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					paramGuardaValoresID = mensajeBean.getConsecutivoInt();

					if(!paramGuardaValoresBean.getParamGuardaValoresID().equals(String.valueOf(Constantes.ENTERO_CERO))) {
						mensajeBean = bajaParamGuardaValores(paramGuardaValoresBean);
					 	if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

				 	ParamGuardaValoresBean parametrosListaFacultados;
				 	ParamGuardaValoresBean parametrosListaDocumentos;

				 	// Valido que la lista de facultados tenga un elemento
				 	if(listaFacultados.size() == 0 || listaFacultados.isEmpty()) {
				 		mensajeBean.setNumero(1);
				 		mensajeBean.setDescripcion("La lista de Documentos esta Vacia");
				 		mensajeBean.setNombreControl("agregaEsquemaDocumento");
						throw new Exception(mensajeBean.getDescripcion());
				 	}

				 	// Valido que la lista de documentos tenga un elemento
				 	if(listaDocumentos.size() == 0 || listaDocumentos.isEmpty()) {
				 		mensajeBean.setNumero(1);
				 		mensajeBean.setDescripcion("La lista de Documentos esta Vacia");
				 		mensajeBean.setNombreControl("agregaEsquemaDocumento");
						throw new Exception(mensajeBean.getDescripcion());
				 	}

				 	// Alta de facultados
					for(int iteracion=0; iteracion<listaFacultados.size(); iteracion++){
						parametrosListaFacultados = (ParamGuardaValoresBean)listaFacultados.get(iteracion);
						parametrosListaFacultados.setParamGuardaValoresID(paramGuardaValoresID);
						mensajeBean = altaFacultados(parametrosListaFacultados);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					// Alta de Documentos
					for(int iteracion=0; iteracion<listaDocumentos.size(); iteracion++){
						parametrosListaDocumentos = (ParamGuardaValoresBean)listaDocumentos.get(iteracion);
						parametrosListaDocumentos.setParamGuardaValoresID(paramGuardaValoresID);
						mensajeBean = altaDocumentos(parametrosListaDocumentos);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean.setConsecutivoInt(paramGuardaValoresID);
					mensajeBean.setConsecutivoString(paramGuardaValoresID);
					mensajeBean.setDescripcion("Configuracion Registrada Correctamente.");

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de Parametros de Guarda de Valores ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} //Fin Proceso de Alta de Parametros de Guarda Valores

	// Proceso de Modificacion de Parametros de Guarda Valores
	public MensajeTransaccionBean modificaParametros(final ParamGuardaValoresBean paramGuardaValoresBean, final List listaFacultados, final List listaDocumentos) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Baja de paremetros Guarda valores
					mensajeBean = bajaParamGuardaValores(paramGuardaValoresBean);
				 	if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

				 	// Alta de parametros Guarda Valores
				 	mensajeBean = altaParamGuardaValores(paramGuardaValoresBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

				 	ParamGuardaValoresBean parametrosListaFacultados;
				 	ParamGuardaValoresBean parametrosListaDocumentos;

				 	// Valido que la lista de facultados tenga un elemento
				 	if(listaFacultados.size() == 0 || listaFacultados.isEmpty()) {
				 		mensajeBean.setNumero(1);
				 		mensajeBean.setDescripcion("La lista de Documentos esta Vacia");
				 		mensajeBean.setNombreControl("agregaEsquemao");
						throw new Exception(mensajeBean.getDescripcion());
				 	}

				 	// Valido que la lista de documentos tenga un elemento
				 	if(listaDocumentos.size() == 0 || listaDocumentos.isEmpty()) {
				 		mensajeBean.setNumero(1);
				 		mensajeBean.setDescripcion("La lista de Documentos esta Vacia");
				 		mensajeBean.setNombreControl("agregaEsquemaDocumento");
						throw new Exception(mensajeBean.getDescripcion());
				 	}

					for(int iteracion=0; iteracion<listaFacultados.size(); iteracion++){
						parametrosListaFacultados = (ParamGuardaValoresBean)listaFacultados.get(iteracion);
						parametrosListaFacultados.setParamGuardaValoresID(paramGuardaValoresBean.getParamGuardaValoresID());
						mensajeBean = altaFacultados(parametrosListaFacultados);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					for(int iteracion=0; iteracion<listaDocumentos.size(); iteracion++){
						parametrosListaDocumentos = (ParamGuardaValoresBean)listaDocumentos.get(iteracion);
						parametrosListaDocumentos.setParamGuardaValoresID(paramGuardaValoresBean.getParamGuardaValoresID());
						mensajeBean = altaDocumentos(parametrosListaDocumentos);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean.setConsecutivoInt(paramGuardaValoresBean.getParamGuardaValoresID());
					mensajeBean.setConsecutivoString(paramGuardaValoresBean.getParamGuardaValoresID());
					mensajeBean.setDescripcion("Configuracion Registrada Correctamente.");

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Modificacion de Parametros de Guarda de Valores ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// Fin Proceso de Modificacion de Parametros de Guarda Valores

	// Alta de Parametros de Guarda Valores
	public MensajeTransaccionBean altaParamGuardaValores(final ParamGuardaValoresBean paramGuardaValoresBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL PARAMGUARDAVALORESALT(?,?,?,?,?,"
																		 +"?,"
																		 +"?,?,?,"
																		 +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_UsuarioAdmon", Utileria.convierteEntero(paramGuardaValoresBean.getUsuarioAdmon()));
								sentenciaStore.setString("Par_CorreoRemitente", paramGuardaValoresBean.getCorreoRemitente());
								sentenciaStore.setString("Par_ServidorCorreo", paramGuardaValoresBean.getServidorCorreo());
								sentenciaStore.setString("Par_Puerto", paramGuardaValoresBean.getPuerto());
								sentenciaStore.setString("Par_UsuarioServidor", paramGuardaValoresBean.getUsuarioServidor());

								sentenciaStore.setString("Par_Contrasenia", paramGuardaValoresBean.getContrasenia());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de Parametros de Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}//Fin Alta de Parametros de Guarda Valores

	// Modificacion de Parametros de Guarda Valores
	public MensajeTransaccionBean bajaParamGuardaValores(final  ParamGuardaValoresBean paramGuardaValoresBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL PARAMGUARDAVALORESBAJ(?,"
																		 +"?,?,?,"
																		 +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ParamGuardaValoresID", Utileria.convierteEntero(paramGuardaValoresBean.getParamGuardaValoresID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Baja de Parametros de Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// Fin  Modificacion de Parametros de Guarda Valores

	// Alta Documentos de Guarda Valores
	public MensajeTransaccionBean altaDocumentos(final ParamGuardaValoresBean paramGuardaValoresBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL DOCGUARDAVALORESALT(?,?," +
																		"?,?,?,"
																	   +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ParamGuardaValoresID", Utileria.convierteEntero(paramGuardaValoresBean.getParamGuardaValoresID()));
								sentenciaStore.setInt("Par_DocumentoID", Utileria.convierteEntero(paramGuardaValoresBean.getDocumentoID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Baja de los Usuarios Facultados en los Parametros de Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} // Fin Baja Facultados de Guarda Valores

	// Alta Facultados de Guarda Valores
	public MensajeTransaccionBean altaFacultados(final ParamGuardaValoresBean paramGuardaValoresBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL USRGUARDAVALORESALT(?,?,?,"
																	   +"?,?,?,"
																	   +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ParamGuardaValoresID", Utileria.convierteEntero(paramGuardaValoresBean.getParamGuardaValoresID()));
								sentenciaStore.setString("Par_PuestoFacultado", paramGuardaValoresBean.getPuestoFacultado());
								sentenciaStore.setInt("Par_UsuarioFacultadoID", Utileria.convierteEntero(paramGuardaValoresBean.getUsuarioFacultadoID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de los Usuarios Facultados en los Parametros de Guarda Valores ", exception);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} // Fin Alta Facultados de Guarda Valores

	// Consulta Principal Guarda Valores
	public ParamGuardaValoresBean consultaPrincipal(final ParamGuardaValoresBean paramGuardaValoresBean, final int tipoConsulta) {

		ParamGuardaValoresBean paramGuardaValores = null;
		//Query con el Store Procedure
		try{
			String query = "CALL PARAMGUARDAVALORESCON(?,?,?,"
													 +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(paramGuardaValoresBean.getParamGuardaValoresID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ParamGuardaValoresDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL PARAMGUARDAVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamGuardaValoresBean parametros = new ParamGuardaValoresBean();

					parametros.setParamGuardaValoresID(resultSet.getString("ParamGuardaValoresID"));
					parametros.setUsuarioAdmon(resultSet.getString("UsuarioAdmon"));
					parametros.setCorreoRemitente(resultSet.getString("CorreoRemitente"));
					parametros.setNombreEmpresa(resultSet.getString("NombreEmpresa"));
					parametros.setNombreUsuarioAdmon(resultSet.getString("NombreUsuarioAdmon"));

					parametros.setServidorCorreo(resultSet.getString("ServidorCorreo"));
					parametros.setPuerto(resultSet.getString("Puerto"));
					parametros.setUsuarioServidor(resultSet.getString("UsuarioServidor"));
					parametros.setContrasenia(resultSet.getString("Contrasenia"));

					return parametros;
				}
			});

			paramGuardaValores = matches.size() > 0 ? (ParamGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de parametros de Guarda Valores ", exception);
			paramGuardaValores = null;
		}

		return paramGuardaValores;
	}// Fin Consulta Principal Guarda Valores

	// Consulta Validar Parametros Guarda Valores
	public ParamGuardaValoresBean validaParametros(final ParamGuardaValoresBean paramGuardaValoresBean, final int tipoConsulta) {

		ParamGuardaValoresBean paramGuardaValores = null;
		//Query con el Store Procedure
		try{
			String query = "CALL PARAMGUARDAVALORESCON(?,?,?,"
													 +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(paramGuardaValoresBean.getParamGuardaValoresID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ParamGuardaValoresDAO.validaParametros",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL PARAMGUARDAVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamGuardaValoresBean parametros = new ParamGuardaValoresBean();

					parametros.setParamGuardaValoresID(resultSet.getString("ParamGuardaValoresID"));
					return parametros;
				}
			});

			paramGuardaValores = matches.size() > 0 ? (ParamGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de parametros de Guarda Valores ", exception);
			paramGuardaValores = null;
		}

		return paramGuardaValores;
	}// Fin Consulta Principal Guarda Valores

	// Consulta Validar usuario Admon Guarda Valores
	public ParamGuardaValoresBean validaUsuarioAdmon(final ParamGuardaValoresBean paramGuardaValoresBean, final int tipoConsulta) {

		ParamGuardaValoresBean paramGuardaValores = null;
		//Query con el Store Procedure
		try{
			String query = "CALL PARAMGUARDAVALORESCON(?,?,?,"
													 +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(paramGuardaValoresBean.getParamGuardaValoresID()),
				Utileria.convierteEntero(paramGuardaValoresBean.getUsuarioAdmon()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ParamGuardaValoresDAO.validaParametros",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL PARAMGUARDAVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamGuardaValoresBean parametros = new ParamGuardaValoresBean();

					parametros.setParamGuardaValoresID(resultSet.getString("ParamGuardaValoresID"));
					return parametros;
				}
			});

			paramGuardaValores = matches.size() > 0 ? (ParamGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de parametros de Guarda Valores ", exception);
			paramGuardaValores = null;
		}

		return paramGuardaValores;
	}// Fin Validar usuario Admon Guarda Valores

	// Lista Facultados Guarda Valores
	public List<ParamGuardaValoresBean> listaFacultados(final ParamGuardaValoresBean paramGuardaValoresBean, final int tipoLista) {

		List<ParamGuardaValoresBean> listaFacultados = null;
		//Query con el Store Procedure
		try{
			String query = "CALL USRGUARDAVALORESLIS(?,?,?,"
												   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(paramGuardaValoresBean.getUsrGuardaValoresID()),
				Utileria.convierteEntero(paramGuardaValoresBean.getParamGuardaValoresID()),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ParamGuardaValoresDAO.listaFacultados",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL USRGUARDAVALORESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamGuardaValoresBean  paramGuardaValores = new ParamGuardaValoresBean();

					paramGuardaValores.setUsrGuardaValoresID(resultSet.getString("UsrGuardaValoresID"));
					paramGuardaValores.setParamGuardaValoresID(resultSet.getString("ParamGuardaValoresID"));
					paramGuardaValores.setPuestoFacultado(resultSet.getString("PuestoFacultado"));
					paramGuardaValores.setNombrePuestoFacultado(resultSet.getString("NombrePuestoFacultado"));
					paramGuardaValores.setUsuarioFacultadoID(resultSet.getString("UsuarioFacultadoID"));

					paramGuardaValores.setNombreUsuarioFacultado(resultSet.getString("NombreUsuarioFacultado"));
					return paramGuardaValores;
				}
			});

			listaFacultados = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Facultados de Guarda Valores", exception);
			listaFacultados = null;
		}

		return listaFacultados;
	}// Fin Lista Facultados Guarda Valores

	// Lista Documentos Guarda Valores
	public List<ParamGuardaValoresBean> listaDocumentos(final ParamGuardaValoresBean paramGuardaValoresBean, final int tipoLista) {

		List<ParamGuardaValoresBean> listaDocumentos = null;
		//Query con el Store Procedure
		try{
			String query = "CALL DOCGUARDAVALORESLIS(?,?,?,"
												   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(paramGuardaValoresBean.getDocGuardaValoresID()),
				Utileria.convierteEntero(paramGuardaValoresBean.getParamGuardaValoresID()),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ParamGuardaValoresDAO.listaDocumentos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL DOCGUARDAVALORESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamGuardaValoresBean  paramGuardaValores = new ParamGuardaValoresBean();

					paramGuardaValores.setDocGuardaValoresID(resultSet.getString("DocGuardaValoresID"));
					paramGuardaValores.setParamGuardaValoresID(resultSet.getString("ParamGuardaValoresID"));
					paramGuardaValores.setDocumentoID(resultSet.getString("DocumentoID"));
					paramGuardaValores.setNombreDocumento(resultSet.getString("NombreDocumento"));
					return paramGuardaValores;
				}
			});

			listaDocumentos = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Documentos de Guarda Valores", exception);
			listaDocumentos = null;
		}

		return listaDocumentos;
	}// Fin Lista Facultados Guarda Valores

	// Lista Empresa Guarda Valores
	public List<ParamGuardaValoresBean> listaEmpresa(final ParamGuardaValoresBean paramGuardaValoresBean, final int tipoLista) {

		List<ParamGuardaValoresBean> listaempresa = null;
		//Query con el Store Procedure
		try{
			String query = "CALL PARAMGUARDAVALORESLIS(?,?,?,"
												     +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(paramGuardaValoresBean.getParamGuardaValoresID()),
				paramGuardaValoresBean.getNombreEmpresa(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ParamGuardaValoresDAO.listaFacultados",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL PARAMGUARDAVALORESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamGuardaValoresBean  paramGuardaValores = new ParamGuardaValoresBean();

					paramGuardaValores.setParamGuardaValoresID(resultSet.getString("ParamGuardaValoresID"));
					paramGuardaValores.setNombreEmpresa(resultSet.getString("NombreEmpresa"));
					return paramGuardaValores;
				}
			});

			listaempresa = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de empresa de Guarda Valores", exception);
			listaempresa = null;
		}

		return listaempresa;
	}// Fin Lista Facultados Guarda Valores

	// Consulta para Validar los puestos facultados en Guarda Valores
	public ParamGuardaValoresBean validaPuestoFacultado(final ParamGuardaValoresBean paramGuardaValoresBean, final int tipoConsulta) {

		ParamGuardaValoresBean paramGuardaValores = null;
		//Query con el Store Procedure
		try{
			String query = "CALL USRGUARDAVALORESCON(?,?,?,?,"
												   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				paramGuardaValoresBean.getPuestoFacultado(),
				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ParamGuardaValoresDAO.validaPuestoFacultado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL USRGUARDAVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamGuardaValoresBean parametros = new ParamGuardaValoresBean();

					parametros.setUsrGuardaValoresID(resultSet.getString("UsrGuardaValoresID"));
					return parametros;
				}
			});

			paramGuardaValores = matches.size() > 0 ? (ParamGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta para validar los puestos facultados de Guarda Valores ", exception);
			paramGuardaValores = null;
		}

		return paramGuardaValores;
	}// Consulta para Validar los puestos facultados en Guarda Valores

	// Consulta para Validar los usuarios facultados en Guarda Valores
	public ParamGuardaValoresBean validaUsuarioFacultado(final ParamGuardaValoresBean paramGuardaValoresBean, final int tipoConsulta) {

		ParamGuardaValoresBean paramGuardaValores = null;
		//Query con el Store Procedure
		try{
			String query = "CALL USRGUARDAVALORESCON(?,?,?,?,"
												   +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(paramGuardaValoresBean.getUsuarioFacultadoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ParamGuardaValoresDAO.validaUsuarioFacultado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL USRGUARDAVALORESCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamGuardaValoresBean parametros = new ParamGuardaValoresBean();

					parametros.setUsrGuardaValoresID(resultSet.getString("UsrGuardaValoresID"));
					return parametros;
				}
			});

			paramGuardaValores = matches.size() > 0 ? (ParamGuardaValoresBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta para validar los usuarios facultados de Guarda Valores ", exception);
			paramGuardaValores = null;
		}

		return paramGuardaValores;
	}// Consulta para Validar los usuarios facultados en Guarda Valores

}
