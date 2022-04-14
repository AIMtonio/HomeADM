package fira.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import credito.bean.RompimientoGrupoBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class RompimientoGrupoAgroDAO extends BaseDAO {

	ParametrosSesionBean parametrosSesionBean;

	public RompimientoGrupoAgroDAO(){
		super();
	}

	/* Procesa el rompimiento del grupo, desintegrando a un cliente del grupo de credito */
	public MensajeTransaccionBean rompimientoGrupo(final RompimientoGrupoBean rompimientoGrupoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		@SuppressWarnings("unchecked")
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "CALL ROMPIMIENTOSGRUPOAGROPRO(?,?,?,?,?," +
																		 "?," +
																		 "?,?,?," +
																		 "?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(rompimientoGrupoBean.getGrupoID()));
							sentenciaStore.setInt("Par_Ciclo", Utileria.convierteEntero(rompimientoGrupoBean.getCicloActual()));
							sentenciaStore.setLong("Par_SolicitudCreditoID", Utileria.convierteLong(rompimientoGrupoBean.getSolicitudCreditoID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(rompimientoGrupoBean.getUsuarioID()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(rompimientoGrupoBean.getSucursalID()));

							sentenciaStore.setString("Par_Motivo", rompimientoGrupoBean.getMotivo());

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

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL ROMPIMIENTOSGRUPOAGROPRO(" + sentenciaStore.toString() + ")");
							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public
					});// CallableStatementCallback

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesar rompimiento de grupo Agro", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// fin de procesar

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
