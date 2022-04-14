package cliente.dao;

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

import cliente.bean.PaisesBean;

public class PaisesDAO extends BaseDAO{


		public PaisesDAO() {
			super();
			// TODO Auto-generated constructor stub
		}

	// ------------------ Transacciones ------------------------------------------

		//consulta de Países
			public PaisesBean consultaPais(Long paisID, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call PAISESCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	paisID,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"PaisesDAO.consultaPais",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAISESCON(" + Arrays.toString(parametros) + ")");

			PaisesBean paises = new PaisesBean();
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PaisesBean paises = new PaisesBean();

					paises.setPaisID(Utileria.completaCerosIzquierda(resultSet.getLong("PaisID"), 5));
					paises.setEmpresaID(Utileria.completaCerosIzquierda(resultSet.getLong("EmpresaID"), 10));
					paises.setNombre(resultSet.getString("Nombre"));
					paises.setGentilicio(resultSet.getString("Gentilicio"));



						return paises;

				}
			});
			return matches.size() > 0 ? (PaisesBean) matches.get(0) : null;

		}
			public PaisesBean consultaPaisForanea(Long paisID, int tipoConsulta) {
				//Query con el Store Procedure
				String query = "call PAISESCON(?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {	paisID,
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"PaisesDAO.consultaPais",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAISESCON(" + Arrays.toString(parametros) + ")");

				PaisesBean paises = new PaisesBean();
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						PaisesBean paises = new PaisesBean();

						paises.setPaisID(Utileria.completaCerosIzquierda(resultSet.getLong("PaisID"), 5));
						paises.setNombre(resultSet.getString("Nombre"));




							return paises;

					}
				});
				return matches.size() > 0 ? (PaisesBean) matches.get(0) : null;

			}

			public PaisesBean consultaPaisCNBV(Long paisID, int tipoConsulta) {
				//Query con el Store Procedure
				String query = "call PAISESCON(?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {	paisID,
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"PaisesDAO.consultaPaisCNBV",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAISESCON(" + Arrays.toString(parametros) + ")");

				PaisesBean paises = new PaisesBean();
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						PaisesBean paises = new PaisesBean();

						paises.setPaisCNBV(Utileria.completaCerosIzquierda(resultSet.getLong("PaisCNBV"), 5));
						paises.setNombre(resultSet.getString("Nombre"));




							return paises;

					}
				});
				return matches.size() > 0 ? (PaisesBean) matches.get(0) : null;

			}

			public PaisesBean consultaPaisDIOT(String paisID, int tipoConsulta) {
				//Query con el Store Procedure
				String query = "call PAISESDIOTCON(?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {	paisID,
										tipoConsulta,
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"PaisesDAO.consultaPaisCNBV",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAISESDIOTCON(" + Arrays.toString(parametros) + ")");

				PaisesBean paises = new PaisesBean();
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						PaisesBean paises = new PaisesBean();


						paises.setClavePaisDIOT(resultSet.getString("Clave"));
						paises.setDescPaisDIOT(resultSet.getString("Pais"));
						paises.setNacionalidadDIOT(resultSet.getString("Nacionalidad"));




							return paises;

					}
				});
				return matches.size() > 0 ? (PaisesBean) matches.get(0) : null;

			}

			public PaisesBean consultaResExt(final String paisID, final int tipoConsulta){
				PaisesBean paisBean = null;
				try {
					paisBean = (PaisesBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								//Query con el Store Procedure
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TASASISREXTRAJEROCON("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_PaisID",Utileria.convierteLong(paisID));
									sentenciaStore.setInt("Par_NumConsulta",tipoConsulta);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
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
									PaisesBean resultadoBean = new PaisesBean();
									if(callableStatement.execute()){
										ResultSet resultSet = callableStatement.getResultSet();

										resultSet.next();
										resultadoBean.setPaisID(Utileria.completaCerosIzquierda(resultSet.getLong("PaisID"), 5));
										resultadoBean.setNombre(resultSet.getString	("Nombre"));
										resultadoBean.setPaisIDBase(resultSet.getString("PaisIDBase"));
										resultadoBean.setTasaISR(resultSet.getString("TasaISR"));
										resultadoBean.setFecha(resultSet.getString("Fecha"));
									}
									return resultadoBean;
								}
							});
					return paisBean;
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de paises para aportaciones: ", e);
					return null;
				}
			}

		//Lista de Países
		public List listaPaises(PaisesBean paises, int tipoLista) {
			//Query con el Store Procedure
			String query = "call PAISESLIS(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	paises.getNombre(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"PaisesDAO.listaPaises",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAISESLIS(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PaisesBean paises = new PaisesBean();
					paises.setPaisID(String.valueOf(resultSet.getLong("PaisID")));
					paises.setNombre(resultSet.getString("Nombre"));
					return paises;
				}
			});

			return matches;
		}
		public List listaPaisesCNBV(PaisesBean paises, int tipoLista) {
			//Query con el Store Procedure
			String query = "call PAISESLIS(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	paises.getNombre(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"PaisesDAO.listaPaises",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAISESLIS(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PaisesBean paises = new PaisesBean();
					paises.setPaisCNBV(String.valueOf(resultSet.getLong("PaisCNBV")));
					paises.setNombre(resultSet.getString("Nombre"));
					return paises;
				}
			});

			return matches;
		}
		public List listaPaisesDIOT(PaisesBean paises, int tipoLista) {
			//Query con el Store Procedure
			String query = "call PAISESLIS(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	paises.getNombre(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"PaisesDAO.listaPaises",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAISESLIS(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PaisesBean paises = new PaisesBean();
					paises.setClavePaisDIOT(resultSet.getString("Clave"));
					paises.setDescPaisDIOT(resultSet.getString("Pais"));
					paises.setNacionalidadDIOT(resultSet.getString("Nacionalidad"));
					return paises;
				}
			});

			return matches;
		}

	}
