package nomina.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import nomina.bean.ConvenioNominaBean;

public class BitacoraConveniosNominaDAO extends BaseDAO {
	
	public BitacoraConveniosNominaDAO() {
		super();
	}
	
	public List<?> listaCambiosParamInstNom(int tipoLista, ConvenioNominaBean convenioNominaBean) {
		List<?> lista = null;
		try {
			String query = "CALL HISCONVENIOSNOMINALIS (?,?,?,?,	?,		?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
					Utileria.convierteEntero(convenioNominaBean.getConvenioNominaID()),
					Utileria.convierteFecha(convenioNominaBean.getFechaInicio()),
					Utileria.convierteFecha(convenioNominaBean.getFechaFin()),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"BitacoraConveniosNominaDAO.listaCambParamInstNom",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL HISCONVENIOSNOMINALIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setFechaCambio(resultSet.getString("FechaCambio"));
					resultado.setNombreInstitNomina(resultSet.getString("NombreInstitNomina"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setNumActualizaciones(resultSet.getString("NumActualizaciones"));
					resultado.setNombreCompleto(resultSet.getString("NombreCompleto"));
					resultado.setNombreSucurs(resultSet.getString("NombreSucurs"));
					resultado.setHisConvenioNomID(resultSet.getString("HisConvenioNomID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de cambios en parametros de empresas de nomina", e);
		}
		return lista;
	}
	
	public List reporteExcelTodos(int tipoLista, ConvenioNominaBean convenioNominaBean) {
		List lista = null;
		try {
			String query = "CALL HISCONVENIOSNOMINAREP (?,?,?,?,?,	?,		?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
					Utileria.convierteEntero(convenioNominaBean.getConvenioNominaID()),
					Utileria.convierteFecha(convenioNominaBean.getFechaInicio()),
					Utileria.convierteFecha(convenioNominaBean.getFechaFin()),

					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"BitacoraConveniosNominaDAO.reportExcelTodos",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL HISCONVENIOSNOMINAREP (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setFechaCambio(resultSet.getString("FechaCambio"));
					resultado.setNombreInstitNomina(resultSet.getString("NombreInstitNomina"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setNumActualizaciones(resultSet.getString("NumActualizaciones"));
					resultado.setNombreCompleto(resultSet.getString("NombreCompleto"));
					resultado.setNombreSucurs(resultSet.getString("NombreSucurs"));
					resultado.setHoraCambio(resultSet.getString("HoraCambio"));
					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de cambios en parametros de empresas de nomina", e);
		}
		return lista;
	}
	
	public List reporteExcelIndividual(int tipoLista, ConvenioNominaBean convenioNominaBean) {
		List lista = null;
		try {
			String query = "CALL HISCONVENIOSNOMINAREP (?,?,?,?,?,	?,		?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteLong(convenioNominaBean.getHisConvenioNomID()),
					Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
					Utileria.convierteEntero(convenioNominaBean.getConvenioNominaID()),
					Utileria.convierteFecha(convenioNominaBean.getFechaInicio()),
					Utileria.convierteFecha(convenioNominaBean.getFechaFin()),

					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"BitacoraConveniosNominaDAO.reportExcelIndividual",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL HISCONVENIOSNOMINAREP (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setFechaCambio(resultSet.getString("FechaCambio"));
					resultado.setNombreInstitNomina(resultSet.getString("NombreInstitNomina"));
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setNumActualizaciones(resultSet.getString("NumActualizaciones"));
					resultado.setNombreCompleto(resultSet.getString("NombreCompleto"));
					resultado.setNombreSucurs(resultSet.getString("NombreSucurs"));
					resultado.setHoraCambio(resultSet.getString("HoraCambio"));
					resultado.setCambios(resultSet.getString("Cambios"));
					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de cambios en parametros de empresas de nomina", e);
		}
		return lista;
	}
	
	public List<?> listaConveniosTodos(int tipoLista, ConvenioNominaBean convenioNominaBean) {
		List<?> lista = null;
		try {
			String query = "CALL CONVENIOSNOMINALIS (?,?,?,?,?,	"
													+ "?,?,?,?,?,"
													+ "?);";
			Object[] parametros = {
					Utileria.convierteEntero(convenioNominaBean.getInstitNominaID()),
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ConveniosNominaDAO.listaConveniosNomina",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CONVENIOSNOMINALIS (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConvenioNominaBean resultado = new ConvenioNominaBean();
					resultado.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
					resultado.setInstitNominaID(resultSet.getString("InstitNominaID"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));
					resultado.setFechaRegistro(resultSet.getString("FechaRegistro"));
					resultado.setManejaVencimiento(resultSet.getString("ManejaVencimiento"));
					
					resultado.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					resultado.setDomiciliacionPagos(resultSet.getString("DomiciliacionPagos"));
					resultado.setClaveConvenio(resultSet.getString("ClaveConvenio"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setResguardo(resultSet.getString("Resguardo"));
					
					resultado.setRequiereFolio(resultSet.getString("RequiereFolio"));
					resultado.setManejaQuinquenios(resultSet.getString("ManejaQuinquenios"));
					resultado.setNumActualizaciones(resultSet.getString("NumActualizaciones"));
					resultado.setUsuarioID(resultSet.getString("UsuarioID"));
					resultado.setCorreoEjecutivo(resultSet.getString("CorreoEjecutivo"));
					
					resultado.setComentario(resultSet.getString("Comentario"));
					resultado.setManejaCapPago(resultSet.getString("ManejaCapPago"));
					resultado.setFormCapPago(resultSet.getString("FormCapPago"));
					resultado.setFormCapPagoRes(resultSet.getString("FormCapPagoRes"));
					resultado.setManejaCalendario(resultSet.getString("ManejaCalendario"));
					
					resultado.setManejaFechaIniCal(resultSet.getString("ManejaFechaIniCal"));
					resultado.setNoCuotasCobrar(resultSet.getString("NoCuotasCobrar"));

					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de convenios", e);
		}
		return lista;
	}
}