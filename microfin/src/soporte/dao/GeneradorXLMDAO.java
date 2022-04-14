package soporte.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import soporte.bean.GeneradorXMLBean;
import soporte.bean.GeneradorXMLEtiquetasBean;
import soporte.bean.ReporteBean;
import soporte.bean.ReporteParametrosBean;

public class GeneradorXLMDAO extends BaseDAO{

	public static interface Enum_Con_Reporte {
		int ENCABEZADO = 1;
		int PARAMETROS = 2;
		int ETIQUETAS = 3;
	}
	public static interface Enum_Tipo_Dato {
		int ENTERO = 1;
		int VARCHAR = 2;
		int DECIMAL = 3;
		int FECHA = 4;
		int LONG = 5;
	}

	public GeneradorXMLBean encabezado(final GeneradorXMLBean bean, int encabezado) {
		String query = "call GENERADORXLMCON("
				+ "?,?,?,?,?,		?,?,?,?);";
		Object[] parametros = {
				Enum_Con_Reporte.ENCABEZADO,
				bean.getReporteID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"GeneradorXLMDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call GENERADORXLMCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				bean.setReporteID(resultSet.getString("ReporteID"));
				bean.setNombreReporte(resultSet.getString("NombreReporte"));
				bean.setDescripcionReporte(resultSet.getString("DescripcionReporte"));
				bean.setNombreArchivo(resultSet.getString("NombreArchivo"));
				bean.setNombreSP(resultSet.getString("NombreSP"));
				bean.setElementoRoot(resultSet.getString("ElementoRoot"));
				bean.setRutaRep(resultSet.getString("RutaRep"));
				bean.setExtension(resultSet.getString("Extension"));
				return bean;
			}
		});
		return bean;
	}
	
	/**
	 * Regresa la lista de parametros para llamada del SP del Reporte
	 * @param bean : {@link ReporteBean} contiene los valores de los filtros para obtener los datos
	 * @return List<String>
	 */
	public List<ReporteParametrosBean> getParametros(GeneradorXMLBean bean) {
		List<ReporteParametrosBean> matches = null;
		try {
			String query = "call GENERADORXLMCON("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					Enum_Con_Reporte.PARAMETROS,
					Utileria.convierteEntero(bean.getReporteID()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					
					"GeneradorXLMDAO.getParametros",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call GENERADORXLMCON(" + Arrays.toString(parametros) + ")");
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

	public List<GeneradorXMLEtiquetasBean> getEtiquetas(GeneradorXMLBean bean) {
		List<GeneradorXMLEtiquetasBean> matches = null;
		try {
			String query = "call GENERADORXLMCON("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					Enum_Con_Reporte.ETIQUETAS,
					Utileria.convierteEntero(bean.getReporteID()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					
					"GeneradorXLMDAO.getParametros",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call GENERADORXLMCON(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GeneradorXMLEtiquetasBean param=new GeneradorXMLEtiquetasBean ();
					param.setEtiqueta(resultSet.getString("Etiqueta"));
					param.setOrden(resultSet.getInt("Orden"));
					param.setTipo(resultSet.getInt("Tipo"));
					param.setNivel(resultSet.getInt("Nivel"));

					return param;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al obtener las etiquetas del SP.", ex);
		}
		return matches;
	}

	public List<List<String>> getFilas(final GeneradorXMLBean bean) {
		List<List<String>> matches = null;
		try {
			System.out.println("Nombre: "+bean.getNombreSP());
			System.out.println("NumParametros: "+bean.getParametros().size());
			String query = "call "+bean.getNombreSP()+"(";
			
			for(int i=0;i<bean.getParametros().size();i++) {
				query=query+"?,";
			}
			query=query+"?,?,?,?,?,		"
					+ "?,?);";
			System.out.println("::::>"+bean.getValorParam().size());
			Object[] parametros=new Object[bean.getValorParam().size()+7];
			int param=0;
			for(param=0;param<bean.getValorParam().size();param++) {
				System.out.println("Parametros: "+bean.getValorParam().get(param));
				parametros[param]=bean.getValorParam().get(param);
			}
			parametros[param++]=Constantes.ENTERO_CERO;/*Empresa*/
 			parametros[param++]=Constantes.ENTERO_CERO;/*Usuario*/
			parametros[param++]=Constantes.FECHA_VACIA;/*FechaActual*/
			parametros[param++]=Constantes.STRING_VACIO;/*DireccionIP*/
			parametros[param++]="GeneradorXLMDAO.getFilas";/*PROGRAMA*/
			parametros[param++]=Constantes.ENTERO_CERO;
			parametros[param++]=Constantes.ENTERO_CERO;
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call "+bean.getNombreSP()+"(" + Arrays.toString(parametros) + ")");
			matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					List<String> lista=new ArrayList<String>();
					for(int i=1;i<=bean.getEtiquetas().size();i++) {
						lista.add(resultSet.getString(i));
					}
					return lista;
				}
			});
		} catch (Exception ex) {
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al obtener las filas del SP.", ex);
		}
		return matches;
	}
}
