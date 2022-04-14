package credito.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;


import credito.bean.CambioPuestoIntegrantesBean;


public class CambioPuestoIntegrantesDAO extends BaseDAO{
ParametrosSesionBean parametrosSesionBean;

	public CambioPuestoIntegrantesDAO(){
		super();
	}

	// Lista de integrantes de grupo para cambio de puesto
	public List listaIntegrantesGrupo(CambioPuestoIntegrantesBean cambioPuestoIntegrantes, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cambioPuestoIntegrantes.getGrupoID(),
					Utileria.convierteEntero(cambioPuestoIntegrantes.getCiclo()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CambioPuestoIntegrantesDAO.listaIntegrantesGrupo",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CambioPuestoIntegrantesBean integraGrupoBean = new CambioPuestoIntegrantesBean();

				integraGrupoBean.setSolicitudCreditoID(resultSet.getString("Solicitud"));
				integraGrupoBean.setProductoCreditoID(resultSet.getString("Producto"));
				integraGrupoBean.setProspectoID(resultSet.getString("Prospecto"));
				integraGrupoBean.setClienteID(resultSet.getString("Cliente"));
				integraGrupoBean.setNombre(resultSet.getString("Nombre"));
				integraGrupoBean.setMontoSol(resultSet.getString("MontoSolicitado"));
				integraGrupoBean.setMontoAutoriza(resultSet.getString("MontoAutorizado"));
				integraGrupoBean.setFechaInicio(resultSet.getString("FechaInicio"));
				integraGrupoBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				integraGrupoBean.setEstatusSol(resultSet.getString("EstatusSolicitud"));
				integraGrupoBean.setCredito(resultSet.getString("Credito"));
				integraGrupoBean.setEstatusCredito(resultSet.getString("EstatusCredito"));
				integraGrupoBean.setCargo(resultSet.getString("Cargo"));
				integraGrupoBean.setPagareImpreso(resultSet.getString("PagareImpreso"));
				integraGrupoBean.setMontoCredito(resultSet.getString("MontoCredito"));

				return integraGrupoBean;

			}
		});
		return matches;
	}

	/* metodo para que manda llamar el metodo cambio de puesto integrantes grupo*/
	public MensajeTransaccionBean procesarCambioPuesto(final List listaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					CambioPuestoIntegrantesBean bean;

					if(listaBean!=null){
						for(int i=0; i<listaBean.size(); i++){
							/* obtenemos un bean de la lista */
							bean = (CambioPuestoIntegrantesBean)listaBean.get(i);

								mensajeBean = actualizaPuestoIntegrante(bean);

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesa cambio de puesto", e);
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}// fin de modificar

	// Metodo para actualizar Puestos de los integrantes del grupo
	public MensajeTransaccionBean actualizaPuestoIntegrante(final CambioPuestoIntegrantesBean cambioPuestoIntegrantes) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call INTEGRAGRUPOSCREMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(cambioPuestoIntegrantes.getGrupoID()));
									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(cambioPuestoIntegrantes.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_Ciclo",Utileria.convierteEntero(cambioPuestoIntegrantes.getCiclo()));
									sentenciaStore.setInt("Par_Cargo",Utileria.convierteEntero(cambioPuestoIntegrantes.getCargo()));


									//Parametros de Salida
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CambioPuestoIntegrantesDAO.actualizaPuestoIntegrante");
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
							throw new Exception(Constantes.MSG_ERROR + " .CambioPuestoIntegrantesDAO.actualizaPuestoIntegrante");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Actualizacion de Puestos" + e);
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
	//* ============== Getter & Setter =============  //*
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
