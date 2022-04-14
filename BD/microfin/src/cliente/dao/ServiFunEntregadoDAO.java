package cliente.dao;

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

import cliente.bean.ServiFunEntregadoBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ServiFunEntregadoDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	public ServiFunEntregadoDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * Método para realizar el Pago de los Servicios Funerarios, método llamado desde la ventanilla
	 * @param ingresosOperacionesBean : {@link IngresosOperacionesBean} con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean pagoSERVIFUNPro(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PAGOSERVIFUNPRO(?,?,?,?,?,  ?,?,?,?,?,   ?,?,?,?,?, ?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ServiFunFolioID", Utileria.convierteEntero(ingresosOperacionesBean.getServiFunFolioID()));
							sentenciaStore.setInt("Par_ServiFunEntregadoID", Utileria.convierteEntero(ingresosOperacionesBean.getServiFunEntregadoID()));

							sentenciaStore.setString("Par_NombreRecibePago", ingresosOperacionesBean.getNombreCliente());
							sentenciaStore.setInt("Par_TipoIdentiID", Utileria.convierteEntero(ingresosOperacionesBean.getTipoIdentifiCliente()));
							sentenciaStore.setString("Par_FolioIdentific", ingresosOperacionesBean.getFolioIdentifiCliente());
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
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

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
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
						mensajeBean.setDescripcion("Error en mensaje Bean");

						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Error en Catch");
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Pago SERVIFUN", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Pago SERVIFUN", e);
					}
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Consulta principal Servicios Funerarios
	public ServiFunEntregadoBean consultaPrincipal(ServiFunEntregadoBean serviFunEntregadoBean, int tipoConsulta){
		String query = "call SERVIFUNENTREGADOCON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {

				Utileria.convierteEntero(serviFunEntregadoBean.getServiFunFolioID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVIFUNFOLIOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ServiFunEntregadoBean serviFunEntregadoBean = new ServiFunEntregadoBean();

				serviFunEntregadoBean.setServiFunEntregadoID(resultSet.getString("ServiFunEntregadoID"));
				serviFunEntregadoBean.setServiFunFolioID(resultSet.getString("ServiFunFolioID"));
				serviFunEntregadoBean.setClienteID(resultSet.getString("ClienteID"));
				serviFunEntregadoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				serviFunEntregadoBean.setEstatus(resultSet.getString("Estatus"));

				serviFunEntregadoBean.setCantidadEntregado(resultSet.getString("CantidadEntregado"));
				serviFunEntregadoBean.setNombreRecibePago(resultSet.getString("NombreRecibePago"));
				serviFunEntregadoBean.setTipoIdentiID(resultSet.getString("TipoIdentiID"));
				serviFunEntregadoBean.setFolioIdentific(resultSet.getString("FolioIdentific"));
				serviFunEntregadoBean.setFechaEntrega(resultSet.getString("FechaEntrega"));

				serviFunEntregadoBean.setCajaID(resultSet.getString("CajaID"));
				serviFunEntregadoBean.setSucursalID(resultSet.getString("SucursalID"));
			return serviFunEntregadoBean;
			}
		});
		return matches.size() > 0 ? (ServiFunEntregadoBean) matches.get(0) : null;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
