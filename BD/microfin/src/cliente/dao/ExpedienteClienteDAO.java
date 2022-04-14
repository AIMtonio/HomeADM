package cliente.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.ClienteBean;
import cliente.bean.ExpedienteClienteBean;

public class ExpedienteClienteDAO extends BaseDAO {

	ParametrosSesionBean parametrosSesionBean = null;
	ParametrosAuditoriaBean parametrosAuditoriaBean = null;

	public ExpedienteClienteDAO() {
		super();
	}


	/* Registra la Actualizacion del Expediente de un Cliente (alta) */
	public MensajeTransaccionBean alta(final ExpedienteClienteBean bean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = " call CLIENTEEXPEDIENTEALT(?,?,?,?,?,"
																	+ "?,?,?,?,?,"
																	+ "?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(bean.getClienteID()));
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID","ExpedienteClienteDAO.alta");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							} else {
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

			} catch (Exception e){
				if (mensajeBean.getNumero() == 0) {
					mensajeBean.setNumero(999);
				}
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error la actualizacion del expediente del cliente", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

			}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public ExpedienteClienteBean consulta(ExpedienteClienteBean clienteBean, int tipoConsulta) {
		String query = " call CLIENTEEXPEDIENTECON(?,?,"
												+ "?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getClienteID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ExpedienteClienteDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEEXPEDIENTECON(" + Arrays.toString(parametros) + ");");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros,new RowMapper(){
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ExpedienteClienteBean expediente = new ExpedienteClienteBean();
				expediente.setClienteNombre(resultSet.getString("ClienteNombre"));
				expediente.setUsuarioNombre(resultSet.getString("UsuarioNombre"));
				expediente.setFechaExpediente(resultSet.getString("FechaExpediente"));
				expediente.setFechaActual(resultSet.getString("FechaActual"));

				return expediente;
			}
		});
		return matches.size() > 0 ? (ExpedienteClienteBean) matches.get(0) : null;
	}

	public ExpedienteClienteBean consultaFechaExpediente(
			ExpedienteClienteBean clienteBean, int tipoConsulta) {
		String query = " call CLIENTEEXPEDIENTECON(?,?,"
												+ "?,?,?,?,?,?,?);";
		Object[] parametros = {	clienteBean.getClienteID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ExpedienteClienteDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTEEXPEDIENTECON(" + Arrays.toString(parametros) + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros,new RowMapper(){
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ExpedienteClienteBean expediente = new ExpedienteClienteBean();
				expediente.setClienteID(resultSet.getString("ClienteID"));
				expediente.setFechaExpediente(resultSet.getString("FechaExpediente"));
				expediente.setTiempo(resultSet.getString("Tiempo"));

				return expediente;
			}
		});
		return matches.size() > 0 ? (ExpedienteClienteBean) matches.get(0) : null;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}


	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
}
