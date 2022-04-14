package cliente.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
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

import cliente.bean.ClienteExMenorBean;


public class ClienteExMenorDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	public ClienteExMenorDAO() {
		super();
	}



	/**
	 * Método para realizar el retiro de los Haberes de Ex menores
	 * @param clienteExMenorBean : {@link ClienteExMenorBean} con la información del cliente
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean retiroHaberesExMenor(final ClienteExMenorBean clienteExMenorBean, final long numtransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CANCSOCMENORCTAPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?,?" + ",?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_FechaOperacion", Utileria.convierteFecha(clienteExMenorBean.getFechaRetiro()));
							sentenciaStore.setString("Par_Operacion", clienteExMenorBean.getTipoOperacion());
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(clienteExMenorBean.getClienteID()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(clienteExMenorBean.getSucursalID()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(clienteExMenorBean.getCajaID()));

							sentenciaStore.setInt("Par_Identidad", Utileria.convierteEntero(clienteExMenorBean.getTipoIdentidad()));
							sentenciaStore.setString("Par_FolioIdenti", clienteExMenorBean.getFolioIdentificacion());
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(clienteExMenorBean.getSaldoAhorro()));

							sentenciaStore.setInt("Par_ConceptoConta", Utileria.convierteEntero(clienteExMenorBean.getConceptoCon()));
							sentenciaStore.setString("Par_DescripcionMov", clienteExMenorBean.getDescripcion());
							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(clienteExMenorBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numtransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en proceso  Retiro de Haberes ExMenor", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en proceso  Retiro de Haberes ExMenor", e);
					}
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

		//consulta principal de Ex-Menores por Cancelación Automatica
	public ClienteExMenorBean consultaPrincipal(ClienteExMenorBean clienteExMenorBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CANCSOCMENORCTACON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {	clienteExMenorBean.getClienteID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteExMenorDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CANCSOCMENORCTACON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClienteExMenorBean clienteExMenor = new ClienteExMenorBean();

					clienteExMenor.setClienteID(herramientas.Utileria.completaCerosIzquierda(
							resultSet.getInt(1), ClienteExMenorBean.LONGITUD_ID));
					clienteExMenor.setCuentaAhoID(resultSet.getString(2));
					clienteExMenor.setSaldoAhorro(resultSet.getString(3));
					clienteExMenor.setEstatusCta(resultSet.getString(4));
					clienteExMenor.setFechaCancela(resultSet.getString(5));
					clienteExMenor.setEstatusRetiro(resultSet.getString(6));
					clienteExMenor.setFechaRetiro(resultSet.getString(7));

					return clienteExMenor;
			}
		});

		return matches.size() > 0 ? (ClienteExMenorBean) matches.get(0) : null;
	}



	//consulta cta  de Ex-Menores
public ClienteExMenorBean consultaCtaExMenor(ClienteExMenorBean clienteExMenorBean, int tipoConsulta) {
	//Query con el Store Procedure
	String query = "call CANCSOCMENORCTACON(?,?,?,?,?, ?,?,?,?);";
	Object[] parametros = {	clienteExMenorBean.getClienteID(),
							tipoConsulta,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"ClienteExMenorDAO.consultaCtaExMenor",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};

	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CANCSOCMENORCTACON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteExMenorBean clienteExMenor = new ClienteExMenorBean();

				clienteExMenor.setClienteID(herramientas.Utileria.completaCerosIzquierda(
						resultSet.getInt(1), ClienteExMenorBean.LONGITUD_ID));
				clienteExMenor.setCuentaAhoID(resultSet.getString(2));
				clienteExMenor.setDescripcion(resultSet.getString(3));

				return clienteExMenor;
		}
	});

	return matches.size() > 0 ? (ClienteExMenorBean) matches.get(0) : null;
}

// método que se utiliza en validaciones ventanilla pago de haberes exmenor
public String consultaEstatusHaberesMenor(ClienteExMenorBean clienteExMenorBean, int tipoConsulta) {
	String estatusHaberesMenor = "";

	try{
		String query = "call CANCSOCMENORCTACON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteExMenorBean.getClienteID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteExMenorDAO.ConsultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CANCSOCMENORCTACON(" + Arrays.toString(parametros) + ")");

	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				String estatus = new String();

				estatus=resultSet.getString("Aplicado");
					return estatus;
			}
		});
	estatusHaberesMenor= matches.size() > 0 ? (String) matches.get(0) : "";
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Estatus en Haberes de Socio Menor", e);
	}
	return estatusHaberesMenor;
}






			//Lista principal de socio exmenor
	public List listaPrincipal(ClienteExMenorBean clienteExMenorBean, int tipoLista){
		String query = "call CANCSOCMENORCTALIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteExMenorBean.getClienteID(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ClienteExMenorDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CANCSOCMENORCTALIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteExMenorBean clienteExMenor = new ClienteExMenorBean();
				clienteExMenor.setClienteID(herramientas.Utileria.completaCerosIzquierda(resultSet.getInt(1), ClienteExMenorBean.LONGITUD_ID));
				clienteExMenor.setNombreCompleto(resultSet.getString(2));
				return clienteExMenor;
			}
		});
		return matches;
	}

	public List listaPrincipalVentanilla(ClienteExMenorBean clienteExMenorBean, int tipoLista){
		String query = "call CANCSOCMENORCTALIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteExMenorBean.getClienteID(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ClienteExMenorDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CANCSOCMENORCTALIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClienteExMenorBean clienteExMenor = new ClienteExMenorBean();
				clienteExMenor.setClienteID(herramientas.Utileria.completaCerosIzquierda(resultSet.getInt(1), ClienteExMenorBean.LONGITUD_ID));
				clienteExMenor.setNombreCompleto(resultSet.getString(2));
				clienteExMenor.setDireccionIP(resultSet.getString(3));
				clienteExMenor.setSucursalID(resultSet.getString(4));
				return clienteExMenor;
			}
		});
		return matches;
	}



			// Reporte Exmenores Cancelados Automaticamente Excel//
				public List listaExMenoresCancelados( ClienteExMenorBean clienteExMenorBean){
					List ListaResultado=null;
					try{
					String query = "call CANCSOCMENORAUTREP(?,?,?,?,?, ?,?,?,?,?, ?,?)";

					Object[] parametros ={
										Utileria.convierteFecha(clienteExMenorBean.getFechaInicial()),
										Utileria.convierteFecha(clienteExMenorBean.getFechaFinal()),
										Utileria.convierteEntero(clienteExMenorBean.getSucursalInicial()),
										Utileria.convierteEntero(clienteExMenorBean.getSucursalFinal()),
										Utileria.convierteEntero(clienteExMenorBean.getClienteID()),

							    		parametrosAuditoriaBean.getEmpresaID(),
										parametrosAuditoriaBean.getUsuario(),
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										parametrosAuditoriaBean.getNombrePrograma(),
										parametrosAuditoriaBean.getSucursal(),
										Constantes.ENTERO_CERO};

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CANCSOCMENORAUTREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							ClienteExMenorBean clienteExMenorBean= new ClienteExMenorBean();

							clienteExMenorBean.setClienteID(herramientas.Utileria.completaCerosIzquierda(resultSet.getInt(1),
															ClienteExMenorBean.LONGITUD_ID));
							clienteExMenorBean.setNombreCompleto(resultSet.getString(2));
							clienteExMenorBean.setSaldoAhorro(resultSet.getString(3));
							clienteExMenorBean.setEstatusRetiro(resultSet.getString(4));
							clienteExMenorBean.setFechaCancela(resultSet.getString(5));
							clienteExMenorBean.setFechaRetiro(resultSet.getString(6));
							clienteExMenorBean.setSucursalID(herramientas.Utileria.completaCerosIzquierda(resultSet.getInt(7),
									ClienteExMenorBean.LONGITUDSUC_ID));
							clienteExMenorBean.setNombreSucursal(resultSet.getString(8));
							clienteExMenorBean.setHoraEmision(resultSet.getString(9));

							return clienteExMenorBean ;
						}
					});
					ListaResultado= matches;
					}catch(Exception e){
						 e.printStackTrace();
						 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de ExMenores Cancelados", e);
					}
					return ListaResultado;
				}



















	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
