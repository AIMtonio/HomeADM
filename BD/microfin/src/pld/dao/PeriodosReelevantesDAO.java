package pld.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.jdbc.core.RowMapper;

import pld.bean.EstadosPreocupantesBean;
import pld.bean.PeriodosReelevantesBean;
import pld.bean.ReporteReelevantesBean;

public class PeriodosReelevantesDAO extends BaseDAO {

	java.sql.Date fecha = null;
	public PeriodosReelevantesDAO() {
		super();
	}
	//Lista para combo
			public List listaPrincipal(int tipoLista) {
				//Query con el Store Procedure
				String query = "call PLDPERIODOSREELIS(?,? ,?,?,?,?,?,?,?);";
				Object[] parametros = {	"",tipoLista,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"PeriodosReelevantesDAO.listaPeriodos",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDPERIODOSREELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						PeriodosReelevantesBean periodos = new PeriodosReelevantesBean();
						periodos.setPeriodoReeID(String.valueOf(resultSet.getString(1)));
						periodos.setDescripcion(resultSet.getString(2));
						return periodos;
					}
				});

				return matches;
			}


			public PeriodosReelevantesBean consultaPeriodo(final PeriodosReelevantesBean periodosReelevantesBean, final int tipoConsulta){
				PeriodosReelevantesBean periodosBean =null;

				try {

				//Query con el Store Procedure
					periodosBean = (PeriodosReelevantesBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call PLDPERIODOSREECON(?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_PeriodoReeID",Utileria.convierteEntero(periodosReelevantesBean.getPeriodoReeID()));
									sentenciaStore.setInt("Par_NumCon",tipoConsulta);
									//sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									//sentenciaStore.registerOutParameter("Par_NumErr", Types.CHAR);
									//sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
									sentenciaStore.setDate("Aud_FechaActual", fecha);
									sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
									sentenciaStore.setString("Aud_ProgramaID","consultaNombArch");
									sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
									sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																													DataAccessException {
									PeriodosReelevantesBean periodosReelevantes = new PeriodosReelevantesBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										periodosReelevantes.setMesDiaInicio(resultadosStore.getString(1));
										periodosReelevantes.setMesDiaFin(resultadosStore.getString(2));

									}
									return periodosReelevantes;
								}
							});
				return periodosBean;
			} catch (Exception e) {
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de periodo relevante", e);
				return null;
			}
		}



	}
