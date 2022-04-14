package fira.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;


import fira.bean.MonitorExcedentesBean;

public class MonitorExcedentesDAO extends BaseDAO{
	public MonitorExcedentesDAO(){
		super();
	}

	//Metodo de alta de Excedentes de Riesgo
		public MensajeTransaccionBean grabaListaExcedentes( final List listaParametros,  final int tipoActualizacion , final String fecha) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();

			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						MonitorExcedentesBean excedentesBean;

							if(listaParametros.size()>0){
								for(int i=0; i < listaParametros.size(); i++){
									excedentesBean = new MonitorExcedentesBean();
									excedentesBean = (MonitorExcedentesBean) listaParametros.get(i);

									// alta de Excedentes de Riesgo
									mensajeBean= modificaExcedentes(excedentesBean, tipoActualizacion, fecha);
									if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							 }else{
								mensajeBean.setDescripcion("Lista de Excedentes de Riesgo Vacía");
								throw new Exception(mensajeBean.getDescripcion());
							}

					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Alta de Excedentes de Riesgo", e);
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

		}


		//Alta de Excedentes de Riesgo
		public MensajeTransaccionBean modificaExcedentes(final MonitorExcedentesBean excedentesBean, final int tipoActualizacion, final String fecha) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call EXCEDENTESRIESGOACT(" +
											"?,?,?,?,?,  ?,?,?,?,?," +
											"?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setString("Par_Fecha",Utileria.convierteFecha(fecha));
										sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(excedentesBean.getGrupoID()));
										sentenciaStore.setString("Par_RiesgoID",excedentesBean.getRiesgoID());
										sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(excedentesBean.getClienteID()));
										sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

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
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ExcedentesDAO.altaExcedentes");
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
								throw new Exception(Constantes.MSG_ERROR + " .ExcedentesDAO.altaExcedentes");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Excedentes de Riesgo" + e);
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


		//Lista para el grid con los posibles riesgos
		public List listaExcedentes(String fecha, int tipoLista, MonitorExcedentesBean excedentesBean){
			String query = "call EXCEDENTESRIESGOLIS(?,?,?,?,?, ?,?,?,?);";

			Object[] parametros = {
					tipoLista,
					fecha,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"MonitorExcedebtesDAO.listaExcedentes",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EXCEDENTESRIESGOLIS(  " + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					MonitorExcedentesBean bean = new MonitorExcedentesBean();

					bean.setGrupoID(resultSet.getString("GrupoID"));
					bean.setRiesgoID(resultSet.getString("RiesgoID"));
					bean.setClienteID(resultSet.getString("ClienteID"));
					bean.setNombreIntegrante(resultSet.getString("NombreIntegrante"));
					bean.setTipoPersona(resultSet.getString("TipoPersona"));
					bean.setRfc(resultSet.getString("RFC"));
					bean.setCurp(resultSet.getString("CURP"));
					bean.setSaldoIntegrante(resultSet.getString("SaldoIntegrante"));
					bean.setSaldoGrupal(resultSet.getString("SaldoGrupal"));

					return bean;
				}
			});

			return matches;
		}

}
