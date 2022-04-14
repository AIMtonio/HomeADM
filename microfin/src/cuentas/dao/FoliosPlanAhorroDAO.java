package cuentas.dao;

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

import cuentas.bean.FoliosPlanAhorroBean;
import cuentas.bean.TiposPlanAhorroBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class FoliosPlanAhorroDAO extends BaseDAO{

	public MensajeTransaccionBean alta(final FoliosPlanAhorroBean folioPlanAhorro) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean)((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>(){
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean)((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL PLANAHORROPROALT(" +
											"?,?,?,?,?," +
											"?,?,?,?,?," +
											"?,?,?,?,?," +
											"?)";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								try {
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(folioPlanAhorro.getClienteID()));
									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(folioPlanAhorro.getCuentaID()));
									sentenciaStore.setInt("Par_PlanID",Utileria.convierteEntero(folioPlanAhorro.getPlanID()));
									sentenciaStore.setInt("Par_NumFolios",Utileria.convierteEntero(folioPlanAhorro.getSerie()));
									sentenciaStore.setDouble("Par_MontoTotal",Utileria.convierteDoble(folioPlanAhorro.getMontoDep()));

									sentenciaStore.setDate("Par_Fecha",OperacionesFechas.conversionStrDate(folioPlanAhorro.getFecha()));
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TiposPlanAhorroDAO");

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(sentenciaStore.toString());
									return sentenciaStore;
								} catch (Exception e) {
									e.printStackTrace();
									loggerSAFI.info(sentenciaStore.toString());
									return null;
								}
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException{
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()) {
									ResultSet resultadoStore = callableStatement.getResultSet();

									resultadoStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadoStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadoStore.getString(2));
									mensajeTransaccion.setNombreControl("numeroTransaccion");
									mensajeTransaccion.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
								}else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El procedimiento no Regreso Ningun Resultado");
								}
								return mensajeTransaccion;
							}
						}
					);

					if(mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El procedimiento no Regreso Ningun Resultado");

					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setCampoGenerico(e.getMessage());
					transaction.setRollbackOnly();
					loggerSAFI.info("Error en alta de Folios de Plan de Ahorro");
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public FoliosPlanAhorroBean consultaPrincipal(FoliosPlanAhorroBean folioPlanAhorro,int tipoConsulta) {
		FoliosPlanAhorroBean folioPlanAhorroConsulta = new FoliosPlanAhorroBean();
		try {
			String query = "CALL FOLIOSPLANAHORROCON(" +
							"?,?,?,?,?," +
							"?,?,?,?,?," +
							"?)";

			Object[] parametros = {
							Utileria.convierteEntero(folioPlanAhorro.getClienteID()),
							Utileria.convierteLong(folioPlanAhorro.getCuentaID()),
							Utileria.convierteEntero(folioPlanAhorro.getPlanID()),
							tipoConsulta,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"TiposPlanAhorroDAO.consultaPrincipal",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
						};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL FOLIOSPLANAHORROCON("+ Arrays.toString(parametros) +")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper(){
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
					FoliosPlanAhorroBean planAhorro = new FoliosPlanAhorroBean();

					planAhorro.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
					planAhorro.setNombreCliente(resultSet.getString("NombreCompleto"));
					planAhorro.setCuentaID(String.valueOf(resultSet.getLong("CuentaAhoID")));
					planAhorro.setDescCuenta(resultSet.getString("Etiqueta"));
					planAhorro.setPlanID(String.valueOf(resultSet.getInt("PlanID")));

					planAhorro.setNombrePlan(resultSet.getString("Nombre"));
					planAhorro.setMonto(String.valueOf(resultSet.getDouble("DepositoBase")));
					planAhorro.setFechaMeta(String.valueOf(resultSet.getDate("FechaLiberacion")));
					planAhorro.setSaldoActual(String.valueOf(resultSet.getDouble("SaldoActual")));

					return planAhorro;
				}
			});

			return matches.size() > 0 ? (FoliosPlanAhorroBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+" error en consulta principal Folios Plan Ahorro",e);
		}
		return folioPlanAhorroConsulta;
	}

	public List reporteExcel(FoliosPlanAhorroBean repPlanAhorro, int tipoReporte) {
		String query = "CALL FOLIOSPLANAHORROREP(?,?,?,?,?,  ?,?,?,?,?,?,?);";

		Object[] parametros  = {
				Integer.parseInt(repPlanAhorro.getPlanID()),
				Integer.parseInt(repPlanAhorro.getSucursal()),
				Integer.parseInt(repPlanAhorro.getClienteID()),
				repPlanAhorro.getEstatus(),
				tipoReporte,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"FoliosPlanAhorroDAO.reporteExcel",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL FOLIOSPLANAHORROREP("+Arrays.toString(parametros)+")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros,new RowMapper() {
			public Object mapRow(ResultSet resultadoSet, int nowNum) throws SQLException{
				FoliosPlanAhorroBean folioPlanAhorro = new FoliosPlanAhorroBean();

				folioPlanAhorro.setClienteID(resultadoSet.getString("ClienteID"));
				folioPlanAhorro.setNombreCliente(resultadoSet.getString("NombreCompleto"));
				folioPlanAhorro.setCuentaID(resultadoSet.getString("CuentaAhoID"));
				folioPlanAhorro.setDescCuenta(resultadoSet.getString("Descripcion"));
				folioPlanAhorro.setSucursal(resultadoSet.getString("NombreSucurs"));

				folioPlanAhorro.setNombrePlan(resultadoSet.getString("Nombre"));
				folioPlanAhorro.setSerie(resultadoSet.getString("Serie"));
				folioPlanAhorro.setEstatus(resultadoSet.getString("Estatus"));
				folioPlanAhorro.setMonto(resultadoSet.getString("Monto"));
				folioPlanAhorro.setFecha(resultadoSet.getString("Fecha"));

				folioPlanAhorro.setFechaCancela(resultadoSet.getString("FechaCancela"));
				folioPlanAhorro.setUsuarioCancela(resultadoSet.getString("UsuarioCancela"));
				folioPlanAhorro.setFechaMeta(resultadoSet.getString("FechaLiberacion"));

				return folioPlanAhorro;
			}

		});

		return matches;
	}

}
