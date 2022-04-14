package cliente.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import herramientas.Constantes;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import soporte.bean.InstrumentosArchivosBean;
import soporte.dao.InstrumentosArchivosDAO;
import soporte.dao.InstrumentosArchivosDAO.Enum_TipoInstrumentos;


import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Utileria;
import cliente.bean.ClienteArchivosBean;

public class ClienteArchivosDAO extends BaseDAO{
	InstrumentosArchivosDAO	instrumentosArchivosDAO = null;

	public ClienteArchivosDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* Alta de Archivo o Documento Digitalizado de Credito	 */
	public MensajeTransaccionArchivoBean altaArchivosCliente(final ClienteArchivosBean archivo) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CLIENTEARCHIVOSALT("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(archivo.getClienteID()));
							sentenciaStore.setInt("Par_ProspectoID", Utileria.convierteEntero(archivo.getProspectoID()));
							sentenciaStore.setInt("Par_TipoDocumen", Utileria.convierteEntero(archivo.getTipoDocumento()));
							sentenciaStore.setString("Par_Observacion", archivo.getObservacion());
							sentenciaStore.setString("Par_Recurso", archivo.getRecurso());

							sentenciaStore.setInt("Par_Instrumento", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_Extension", archivo.getExtension());
							sentenciaStore.setString("Par_FechaRegistro", Utileria.convierteFecha(archivo.getFechaRegistro()));
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString(4));
								mensajeTransaccionArchivoBean.setRecursoOrigen(resultadosStore.getString(5));
							} else {
								mensajeTransaccionArchivoBean.setNumero(999);
								mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccionArchivoBean;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionArchivoBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de archivos cliente" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* Alta de de un archivo digital, en este metodo se envia un valor para el campo Instrumento de la tabla */
	public MensajeTransaccionArchivoBean altaArchivo(final ClienteArchivosBean archivo) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		transaccionDAO.generaNumeroTransaccion();

				mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CLIENTEARCHIVOSALT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?,	?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(archivo.getClienteID()));
							sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(archivo.getProspectoID()));
							sentenciaStore.setInt("Par_TipoDocumen",Utileria.convierteEntero(archivo.getTipoDocumento()));
							sentenciaStore.setString("Par_Observacion",archivo.getObservacion());
							sentenciaStore.setString("Par_Recurso",archivo.getRecurso());
							sentenciaStore.setString("Par_Extension",archivo.getExtension());
							sentenciaStore.setInt("Par_Instrumento",Utileria.convierteEntero(archivo.getInstrumento()));

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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString(4));
								mensajeTransaccionArchivoBean.setRecursoOrigen(resultadosStore.getString(5));
							}else{
								mensajeTransaccionArchivoBean.setNumero(999);
								mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccionArchivoBean;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionArchivoBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de archivos" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	} // fin de alta archivo cliente


	/* Baja de Archivos de Cliente */
	public MensajeTransaccionArchivoBean bajaArchivosCliente(final ClienteArchivosBean archivo) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
				mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CLIENTEARCHIVOSBAJ(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ClienteArID",Utileria.convierteEntero(archivo.getClienteArchivosID()));
							sentenciaStore.setInt("Par_ClienteID",Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_TipoDocumen",archivo.getTipoDocumento());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","ClienteArchivosDAO");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccionArchivoBean = new MensajeTransaccionArchivoBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccionArchivoBean.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccionArchivoBean.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccionArchivoBean.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccionArchivoBean.setConsecutivoString(resultadosStore.getString(4));
							}else{
								mensajeTransaccionArchivoBean.setNumero(999);
								mensajeTransaccionArchivoBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccionArchivoBean;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionArchivoBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en baja de archivos" + e);
					e.printStackTrace();
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

	/* Consulta para ver la imagen de perfil del cliente*/
	public ClienteArchivosBean verImagenPerfil(ClienteArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure

		List matches=null;
		try{
		String query = "call CLIENTEARCHIVOSCON(" +
				"?,?,?,?,?, ?,?,?,?,?, " +
				"?);";
		Object[] parametros = {
				Utileria.convierteEntero(archivo.getClienteID()),
				Utileria.convierteEntero(archivo.getProspectoID()),
				Utileria.convierteEntero(archivo.getTipoDocumento()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSCON(" + Arrays.toString(parametros) + ")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivo = new ClienteArchivosBean();
					archivo.setClienteID(String.valueOf(resultSet.getInt(1)));
					archivo.setRecurso(resultSet.getString(2));
					archivo.setClienteArchivosID(resultSet.getString(3));

					return archivo;

			}
		});

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de imagen" + e);
		}
	 return matches.size() > 0 ? (ClienteArchivosBean) matches.get(0) : null;
	}


	/* Consulta que devuelve un valor si ya existe un documento pld para un cliente*/
	public ClienteArchivosBean consultaArcPLD(ClienteArchivosBean archivo, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIENTEARCHIVOSCON(" +
				"?,?,?,?,?, ?,?,?,?,?, " +
				"?);";
		Object[] parametros = {
				Utileria.convierteEntero(archivo.getClienteID()),
				Utileria.convierteEntero(archivo.getProspectoID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivo = new ClienteArchivosBean();
					archivo.setClienteID(resultSet.getString(1));
					return archivo;
			}
		});
		return matches.size() > 0 ? (ClienteArchivosBean) matches.get(0) : null;
	}


	/* Consulta el numero de documentos que tiene un cliente */
	public ClienteArchivosBean consultaDocumentosPorCliente(ClienteArchivosBean archivo, int tipoConsulta) {
		ClienteArchivosBean clienteArchivosBeanConsulta  = new ClienteArchivosBean();
		try{
			//Query con el Store Procedure
			String query = "call CLIENTEARCHIVOSCON(" +
					"?,?,?,?,?, ?,?,?,?,?," +
					"?);";
			Object[] parametros = {
					Utileria.convierteEntero(archivo.getClienteID()),
					Utileria.convierteEntero(archivo.getProspectoID()),
					archivo.getTipoDocumento(),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"consultaPrincipalArchivosCliente",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClienteArchivosBean archivo = new ClienteArchivosBean();
					archivo.setNumeroDocumentos(resultSet.getString(1));
					return archivo;
				}
			});
			clienteArchivosBeanConsulta= matches.size() > 0 ? (ClienteArchivosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de numeros de clientes", e);
		}
		return clienteArchivosBeanConsulta;
	}

	/* Lista de Archivos por Cliente*/
	public List listaArchivosCliente(ClienteArchivosBean archivoBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTEARCHIVOSLIS(" +
				"?,?,?,?,?, ?,?,?,?,?," +
				"?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(archivoBean.getClienteID()),
				Utileria.convierteEntero(archivoBean.getProspectoID()),
				archivoBean.getTipoDocumento(),
				Constantes.ENTERO_CERO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"listaArchivosCliente",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivoBean = new ClienteArchivosBean();
				archivoBean.setObservacion(resultSet.getString("Observacion"));
				archivoBean.setRecurso(resultSet.getString("Recurso"));
				archivoBean.setTipoDocumento(resultSet.getString("TipoDocumento"));
				archivoBean.setConsecutivo(resultSet.getString("Consecutivo"));
				archivoBean.setClienteArchivosID(resultSet.getString("ClienteArchivosID"));
				archivoBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				archivoBean.setDescTipoDoc(resultSet.getString("Descripcion"));
				return archivoBean;
			}
		});
		return matches;
	}


	/* Lista de Archivos por Cliente y por Instrumento*/
	public List listaArchivos(ClienteArchivosBean archivoBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTEARCHIVOSLIS(" +
				"?,?,?,?,?, ?,?,?,?,?," +
				"?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(archivoBean.getClienteID()),
				Utileria.convierteEntero(archivoBean.getProspectoID()),
				archivoBean.getTipoDocumento(),
				Utileria.convierteEntero(archivoBean.getInstrumento()),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"listaArchivosCliente",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivoBean = new ClienteArchivosBean();
				archivoBean.setObservacion(resultSet.getString("Observacion"));
				archivoBean.setRecurso(resultSet.getString("Recurso"));
				archivoBean.setTipoDocumento(resultSet.getString("TipoDocumento"));
				archivoBean.setConsecutivo(resultSet.getString("Consecutivo"));
				archivoBean.setClienteArchivosID(resultSet.getString("ClienteArchivosID"));
				archivoBean.setInstrumento(resultSet.getString("Instrumento"));
				archivoBean.setFechaRegistro(resultSet.getString("FechaRegistro"));


				return archivoBean;
			}
		});
		return matches;
	}

	/* Lista de Archivos por cliente para el expediente en formato PDF*/
	public List listaArchivosReporte(ClienteArchivosBean archivoBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CLIENTEARCHIVOSLIS(" +
				"?,?,?,?,?, ?,?,?,?,?," +
				"?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(archivoBean.getClienteID()),
				Utileria.convierteEntero(archivoBean.getProspectoID()),
				archivoBean.getTipoDocumento(),
				Utileria.convierteEntero(archivoBean.getInstrumento()),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"listaArchivosCliente",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEARCHIVOSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivoBean = new ClienteArchivosBean();
				archivoBean.setObservacion(resultSet.getString("Observacion"));
				archivoBean.setRecurso(resultSet.getString("Recurso"));
				archivoBean.setTipoDocumento(resultSet.getString("TipoDocumento"));
				archivoBean.setConsecutivo(resultSet.getString("Consecutivo"));
				archivoBean.setClienteArchivosID(resultSet.getString("ClienteArchivosID"));
				archivoBean.setInstrumento(resultSet.getString("Instrumento"));
				archivoBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				archivoBean.setHora(resultSet.getString("Hora"));
				archivoBean.setClienteID(resultSet.getString("ClienteID"));
				archivoBean.setProspectoID(resultSet.getString("ProspectoID"));
				archivoBean.setDescTipDoc(resultSet.getString("DescTipDoc"));
				return archivoBean;
			}
		});
		return matches;
	}

	public List<ClienteArchivosBean> listaArcExpirarPLD(ClienteArchivosBean archivoBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call PLDDOCUMENTOSEXPIRAREP("
				+ "?,?,?,?,?,		"
				+ "?,?,?,?,?,		"
				+ "?,?,?);";
		Object[] parametros = {
				Utileria.convierteFecha(archivoBean.getFechaInicio()),
				Utileria.convierteFecha(archivoBean.getFechaFinal()),
				Utileria.convierteEntero(archivoBean.getSucursal()),
				archivoBean.getNivelRiesgo(),
				archivoBean.getEstatus(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ClienteArchivosDAO.listaArcExpirarPLD",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDDOCUMENTOSEXPIRAREP(" + Arrays.toString(parametros) + ")");
		List<ClienteArchivosBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteArchivosBean archivoBean = new ClienteArchivosBean();
				archivoBean.setSucursal(resultSet.getString("SucursalOrigen"));
				archivoBean.setSucursalDes(resultSet.getString("NombreSucurs"));
				archivoBean.setClienteID(resultSet.getString("ClienteID"));
				archivoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				archivoBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				archivoBean.setFechaExpira(resultSet.getString("FechaExpira"));
				archivoBean.setNivelRiesgo(resultSet.getString("NivelRiesgo"));
				archivoBean.setEstatus(resultSet.getString("Estatus"));
				return archivoBean;
			}
		});
		return matches;
	}

	public MensajeTransaccionArchivoBean procBajaArchivosCliente(final ClienteArchivosBean archivo) {
		MensajeTransaccionArchivoBean mensaje = null;

		final InstrumentosArchivosBean instrumArchivo = new InstrumentosArchivosBean();
		instrumArchivo.setArchivoBajID(archivo.getClienteArchivosID());
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
						if(!archivo.getClienteID().equals("") && !archivo.getClienteID().equals("0") && archivo.getClienteID()!=null){
							instrumArchivo.setNumeroInstrumento(archivo.getClienteID());
							mensajeBean = instrumentosArchivosDAO.altaArchivosAEliminar(instrumArchivo,Enum_TipoInstrumentos.cliente);
						}else if(!archivo.getProspectoID().equals("") && !archivo.getProspectoID().equals("0") || archivo.getProspectoID()!=null){
							instrumArchivo.setNumeroInstrumento(archivo.getProspectoID());
							mensajeBean = instrumentosArchivosDAO.altaArchivosAEliminar(instrumArchivo,Enum_TipoInstrumentos.prospecto);
						}
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						mensajeBean = bajaArchivosCliente(archivo);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Archivos Eliminados de los Instrumentos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public InstrumentosArchivosDAO getInstrumentosArchivosDAO() {
		return instrumentosArchivosDAO;
	}

	public void setInstrumentosArchivosDAO(
			InstrumentosArchivosDAO instrumentosArchivosDAO) {
		this.instrumentosArchivosDAO = instrumentosArchivosDAO;
	}


}
