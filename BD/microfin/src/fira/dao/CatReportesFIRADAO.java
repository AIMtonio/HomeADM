package fira.dao;

import fira.bean.CatReportesFIRABean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

public class CatReportesFIRADAO extends BaseDAO {

	public CatReportesFIRADAO(){
		super();
	}

	/**
	 * Método para generar el reporte financiero elegido desde pantalla.
	 * @param catReportesFIRABean : Clase bean para los valores de los parámetros de entrada al SP-MONITOREOFIRAREP.
	 * @param tipoLista : Número de Lista.
	 * @param numeroTransaccion : Número de transacción.
	 * @return List : Lista de clases bean {@linkplain CatReportesFIRABean}.
	 * @author avelasco
	 */
	public List<CatReportesFIRABean> listaReporte(CatReportesFIRABean catReportesFIRABean, int tipoLista, long numeroTransaccion) {
		List<CatReportesFIRABean> lista=new ArrayList<CatReportesFIRABean>();
		String query = "CALL MONITOREOFIRAREP("
				+ "?,?,?,?,?,   "
				+ "?,?,?,?);";
		Object[] parametros = {
				catReportesFIRABean.getTipoReporteID(),
				catReportesFIRABean.getFechaReporte(),
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),

				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				numeroTransaccion
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call MONITOREOFIRAREP(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		try{
			List<CatReportesFIRABean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatReportesFIRABean parametro = new CatReportesFIRABean();
					parametro.setReporte(resultSet.getString("CSVReporte"));
					return parametro;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en CatReportesFIRADAO.listaReporte: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Método que lista los diferentes tipos de reportes para el monitoreo de la cartera Agro.
	 * @param catReportesFIRABean : Clase bean para los valores de los parámetros de entrada al SP-CATREPORTESFIRALIS.
	 * @param tipoLista : Número de Lista. 1.- Principal.
	 * @return List : Lista de clases bean {@linkplain CatReportesFIRABean}.
	 * @author avelasco
	 */
	public List<CatReportesFIRABean> lista(CatReportesFIRABean catReportesFIRABean, int tipoLista) {
		List<CatReportesFIRABean> lista = new ArrayList<CatReportesFIRABean>();
		try {
			String query = "CALL CATREPORTESFIRALIS("+
							"?,?,?,?,?,   " +
							"?,?,?);";
			Object[] parametros = {
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),

					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "call CATREPORTESFIRALIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
			try {
				List<CatReportesFIRABean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CatReportesFIRABean parametro = new CatReportesFIRABean();
						parametro.setTipoReporteID(resultSet.getString("TipoReporteID"));
						parametro.setNombre((resultSet.getString("Nombre")));
						parametro.setNombreReporte(resultSet.getString("NombreReporte"));
						return parametro;
					}
				});
				if (matches != null) {
					return matches;
				}
			} catch (Exception ex) {
				loggerSAFI.info("Error en CatReportesFIRADAO.lista: " + ex.getMessage());
			}
			return lista;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	/**
	 * Consulta el nombre del archivo a generar en los reportes de monitoreo de la cartera Agro.
	 * @param catReportesFIRABean : Clase bean con los parámetros de entrada al SP-CATREPORTESFIRACON.
	 * @param tipoConsulta : Número de Consulta 1.
	 * @return {@linkplain CatReportesFIRABean} con el nombre del archivo a generar.
	 * @author avelasco
	 */
	public CatReportesFIRABean consultaNombreReporte(final CatReportesFIRABean catReportesFIRABean, final int tipoConsulta, final long numTransaccion){
		CatReportesFIRABean resultadoBean =null;
		try {
			resultadoBean = (CatReportesFIRABean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CATREPORTESFIRACON("
												+ "?,?,?,?,?,	"
												+ "?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_TipoReporteID",Utileria.convierteEntero(catReportesFIRABean.getTipoReporteID()));
							sentenciaStore.setInt("Par_NumConsulta",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);

							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","CatReportesFIRADAO.consultaNombreReporte");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
						DataAccessException {
							CatReportesFIRABean resultadoBean = new CatReportesFIRABean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								resultadoBean.setTipoReporteID(resultadosStore.getString("TipoReporteID"));
								resultadoBean.setNombreReporte(resultadosStore.getString("NombreReporte"));
							}
							return resultadoBean;
						}
					});
			return resultadoBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de Tipos de Reporte Monitoreo FIRA: ", e);
			return null;
		}
	}


	public List<CatReportesFIRABean> listaProyeccion( int tipoLista) {
		List<CatReportesFIRABean> lista = new ArrayList<CatReportesFIRABean>();
		try {
			String query = "CALL CATREPORTESFIRALIS("+
							"?,?,?,?,?,   " +
							"?,?,?);";
			Object[] parametros = {
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),

					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "call CATREPORTESFIRALIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
			try {
				List<CatReportesFIRABean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CatReportesFIRABean parametro = new CatReportesFIRABean();
						parametro.setAnio(resultSet.getString("Anio"));
						return parametro;
					}
				});
				if (matches != null) {
					return matches;
				}
			} catch (Exception ex) {
				loggerSAFI.info("Error en CatReportesFIRADAO.lista: " + ex.getMessage());
			}
			return lista;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	/**
	 * Genera el Número de Transacción.
	 * @return el Número de Transacción.
	 * @author avelasco
	 */
	public long getNumTransaccion(){
		return transaccionDAO.generaNumeroTransaccionOut();
	}
}