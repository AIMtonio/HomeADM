package nomina.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import nomina.bean.ActualizaEstatusEmpBean;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;


import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ActualizaEstatusEmpDAO  extends BaseDAO{
	public ActualizaEstatusEmpDAO(){
		super();
	}
	/* Actualizacion Estatus del Empleado de Nómina */
	public MensajeTransaccionBean actualizaEstatus(final ActualizaEstatusEmpBean actualizaEstatusEmpBean) {
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
								String query = "CALL NOMINAEMPLEADOSMOD (?,?,?,?,?,		" +
																		"?,?,?,?,?,		" +
																		"?,?,?,?,?,		" +
																		"?,?,?,?,?,		" +
																		"?,?,?,?,?,		" +
																		"?,?);			";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_NominaEmpleadoID", Utileria.convierteEntero(actualizaEstatusEmpBean.getNominaEmpleadoID()));

								sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(actualizaEstatusEmpBean.getInstitNominaID()));
								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(actualizaEstatusEmpBean.getClienteID()));
								sentenciaStore.setLong("Par_ProspectoID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_ConvNominaID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_TipoEmpleadoID", Constantes.ENTERO_CERO);

								sentenciaStore.setInt("Par_TipoPuestoID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_NoEmpleado", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_QuinquenioID", Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_CenAdscripcion", Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechaIngreso", Constantes.FECHA_VACIA);

								sentenciaStore.setString("Par_Estatus",actualizaEstatusEmpBean.getEstatus());
								sentenciaStore.setString("Par_FechaInicioInca",Utileria.convierteFecha(actualizaEstatusEmpBean.getFechaInicialInca()));
								sentenciaStore.setString("Par_FechaFinInca",Utileria.convierteFecha(actualizaEstatusEmpBean.getFechaFinInca()));
								sentenciaStore.setString("Par_FechaBaja",Utileria.convierteFecha(actualizaEstatusEmpBean.getFechaBaja()));
								sentenciaStore.setString("Par_MotivoBaja",actualizaEstatusEmpBean.getMotivoBaja());

								sentenciaStore.setString("Par_NoPension", Constantes.STRING_VACIO);

								//Parametros de OutPut
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
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
									//mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));
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
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la actualizacion de estatus", e);
				}
				return mensajeBean;
			}
		  });
		return mensaje;
		}

	/* Consulta Estatus del Empleado de Nómina */
	public ActualizaEstatusEmpBean consultaEstatus(int tipoConsulta, ActualizaEstatusEmpBean actualizaEstatusEmpBean){
		String query = "call NOMINAEMPLEADOSCON(" +
				"?,?,?,?,?,		?,?,?,?,?,	" +
				"?,?,?,?);";
		Object[] parametros = {

				Utileria.convierteEntero(actualizaEstatusEmpBean.getInstitNominaID()),
				Utileria.convierteEntero(actualizaEstatusEmpBean.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				"ActualizaEstatusEmpDAO.consultaEstatus",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMINAEMPLEADOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				ActualizaEstatusEmpBean actualizaEstatusEmpBean = new ActualizaEstatusEmpBean();

				actualizaEstatusEmpBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				actualizaEstatusEmpBean.setEstatus(resultSet.getString("Estatus"));
				actualizaEstatusEmpBean.setFechaInicialInca(resultSet.getString("FechaInicioInca"));
				actualizaEstatusEmpBean.setFechaFinInca(resultSet.getString("FechaFinInca"));
				actualizaEstatusEmpBean.setFechaBaja(resultSet.getString("FechaBaja"));
				actualizaEstatusEmpBean.setMotivoBaja(resultSet.getString("MotivoBaja"));

				return actualizaEstatusEmpBean;
			}
		});

		return matches.size() > 0 ? (ActualizaEstatusEmpBean) matches.get(0) : null;
	}

public List listaEmpleado(int tipoLista, ActualizaEstatusEmpBean actualizaEstatusEmpBean){

		String query = "call NOMINAEMPLEADOSLIS(?,?,?,?,?,		?,?,?,?,?,		?,?,?,?);";
		Object[] parametros = {
				actualizaEstatusEmpBean.getNombreCompleto(),
				Utileria.convierteEntero(actualizaEstatusEmpBean.getInstitNominaID()),
				Utileria.convierteEntero(actualizaEstatusEmpBean.getClienteID()),
				Constantes.DOUBLE_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"EmpleadoNominaDAO.listaEmpleado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMINAEMPLEADOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ActualizaEstatusEmpBean actualizaEstatus = new ActualizaEstatusEmpBean();

				actualizaEstatus.setClienteID(resultSet.getString("ClienteID"));
				actualizaEstatus.setNombreCompleto(resultSet.getString("NombreCompleto"));

				return actualizaEstatus;

			}
		});
		return matches;
	}

}
