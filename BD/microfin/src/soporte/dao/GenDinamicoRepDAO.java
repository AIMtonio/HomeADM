package soporte.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.axis2.transport.mail.SynchronousMailListener;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import soporte.bean.ReporteBean;
import soporte.bean.ReporteColumnasBean;
import soporte.bean.ReporteParametrosBean;

/**
 * 
 * @author pmontero
 * @category Utileria
 */
public class GenDinamicoRepDAO extends BaseDAO {
	
	public static interface Enum_Con_Reporte {
		int VISTA = 1;
		int ENCABEZADO = 2;
		int PARAMETROS = 3;
		int COLUMNAS = 4;
	}
	public static interface Enum_Tipo_Dato {
		int ENTERO = 1;
		int VARCHAR = 2;
		int DECIMAL = 3;
		int FECHA = 4;
		int LONG = 5;
	}
	
	/**
	 * Obtiene la ruta de la vista.
	 * @param bean
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String getVista(ReporteBean bean) {
		String vista = "";
		try {
			List<ReporteBean> matches = null;
			String query = "call REPORTEDINAMICON(" + "?,?,?,?,?,				" + "?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(bean.getReporteID()),
					Enum_Con_Reporte.VISTA,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"GenDinamicoRepDAO.getVista",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call REPORTEDINAMICON(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteBean lista = new ReporteBean();
					lista.setVista(resultSet.getString("Vista"));
					return lista;
				}
			});
			vista = matches.size() > 0 ? matches.get(0).getVista() : null;
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al obtener la vista.", ex);
		}
		return vista;
	}

	/**
	 * Obtiene los datos del encabezado de reporte, el nombre del SP y otras configuraciones.
	 * @param bean
	 * @param numeroConsulta
	 * @return
	 */
	public ReporteBean encabezado(final ReporteBean bean, int numeroConsulta) {
		ReporteBean resultado = null;
		try {
			List<ReporteBean> matches = null;
			String query = "call REPORTEDINAMICON("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(bean.getReporteID()),
					numeroConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					
					"GeneradorExcelDinamicoDAO.encabezado",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call REPORTEDINAMICON(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
//					ReporteBean lista = new ReporteBean();

					bean.setReporteID(resultSet.getString("ReporteID"));
					bean.setTituloReporte(resultSet.getString("TituloReporte")+" "+String.valueOf(bean.getTituloReporte()));
					bean.setNombreArchivo(resultSet.getString("NombreArchivo"));
					bean.setNombreSP(resultSet.getString("NombreSP"));
					bean.setNombreHoja(resultSet.getString("NombreHoja"));

					return bean;
				}
			});
			resultado = matches.size() > 0 ? matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al obtener el encabezado del reporte.", ex);
		}
		return resultado;
	}
	
	/**
	 * Regresa la lista de parametros para llamada del SP del Reporte
	 * @param bean : {@link ReporteBean} contiene los valores de los filtros para obtener los datos
	 * @return List<String>
	 */
	public List<ReporteParametrosBean> getParametros(ReporteBean bean) {
		List<ReporteParametrosBean> matches = null;
		try {
			String query = "call REPORTEDINAMICON("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(bean.getReporteID()),
					Enum_Con_Reporte.PARAMETROS,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					
					"GeneradorExcelDinamicoDAO.getParametros",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call REPORTEDINAMICON(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteParametrosBean param=new ReporteParametrosBean();
					param.setNombreParametro(resultSet.getString("NombreParametro"));
					param.setOrden(resultSet.getInt("Orden"));
					param.setTipo(resultSet.getInt("Tipo"));
					return param;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al obtener los parametros del SP.", ex);
		}
		return matches;
	}

	/**
	 * Obtiene las Columnas del Reporte estas deben de estar parametrizadas en la siguiente tabla:
	 * TABLA: REPDINAMICOCOLUM
	 * @param bean : {@link ReporteBean} contiene el ID del reporte del que se van a traer las columnas.
	 * @return
	 */
	public List<ReporteColumnasBean> getColumnas(ReporteBean bean) {
		List<ReporteColumnasBean> matches = null;
		try {
			String query = "call REPORTEDINAMICON("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(bean.getReporteID()),
					Enum_Con_Reporte.COLUMNAS,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					
					"GeneradorExcelDinamicoDAO.getColumnas",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call REPORTEDINAMICON(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteColumnasBean param=new ReporteColumnasBean();
					param.setNombreColumna(resultSet.getString("NombreColumna"));
					param.setOrden(resultSet.getInt("Orden"));
					param.setTipo(resultSet.getInt("Tipo"));
					return param;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al obtener las columnas del SP.", ex);
		}
		return matches;
	}

	public List<List<String>> getFilas(final ReporteBean bean) {
		List<List<String>> matches = null;
		try {
			String query = "call "+bean.getNombreSP()+"(";
			
			for(int i=0;i<bean.getParametros().size();i++) {
				query=query+"?,";
			}
			query=query+"?,?,?,?,?,		"
					+ "?,?);";
			Object[] parametros=new Object[bean.getValorParam().size()+7];
			int param=0;
			for(param=0;param<bean.getValorParam().size();param++) {
				parametros[param]=bean.getValorParam().get(param);
			}
			parametros[param++]=Constantes.ENTERO_CERO;/*Empresa*/
 			parametros[param++]=Constantes.ENTERO_CERO;/*Usuario*/
			parametros[param++]=Constantes.FECHA_VACIA;/*FechaActual*/
			parametros[param++]=Constantes.STRING_VACIO;/*DireccionIP*/
			parametros[param++]="GeneradorExcelDinamicoDAO.getParametros";/*PROGRAMA*/
			parametros[param++]=Constantes.ENTERO_CERO;
			parametros[param++]=Constantes.ENTERO_CERO;
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call "+bean.getNombreSP()+"(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					List<String> lista=new ArrayList<String>();
					for(int i=1;i<=bean.getColumnas().size();i++) {
						lista.add(resultSet.getString(i));
					}
					return lista;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al obtener los parametros del SP.", ex);
		}
		return matches;
	}
}
