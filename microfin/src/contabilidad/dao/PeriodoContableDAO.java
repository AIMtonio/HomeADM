package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import contabilidad.bean.ConceptoContableBean;
import contabilidad.bean.EjercicioContableBean;
import contabilidad.bean.PeriodoContableBean;
import contabilidad.bean.PolizaBean;

public class PeriodoContableDAO extends BaseDAO {

	public PeriodoContableDAO() {
		super();
	}

	public MensajeTransaccionBean altaPeriodo(final PeriodoContableBean periodoContableBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();		
		try{
		
			String query = "call PERIODOCONTABLEALT(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {					
					herramientas.Utileria.convierteEntero(periodoContableBean.getNumeroEjercicio()),
					periodoContableBean.getTipoPeriodo(),					
					periodoContableBean.getInicioPeriodo(),
					periodoContableBean.getFinPeriodo(),
					parametrosAuditoriaBean.getEmpresaID(),					
					
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PeriodoContableDAO.altaPeriodo",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERIODOCONTABLEALT(" + Arrays.toString(parametros) + ")");
	
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					return mensaje;
				}
			});
			mensaje =  matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
		} catch (Exception e) {
			
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de periodo contable", e);
		}
		return mensaje;		
	}
	
	public MensajeTransaccionBean cierrePeriodo(final PeriodoContableBean periodoContableBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();		
		try{
		
			String query = "call PERIODOCONTACIEPRO(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {					
					herramientas.Utileria.convierteEntero(periodoContableBean.getNumeroEjercicio()),
					herramientas.Utileria.convierteEntero(periodoContableBean.getNumeroPeriodo()),
					parametrosAuditoriaBean.getEmpresaID(),					
					
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PeriodoContableDAO.cierrePeriodo",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERIODOCONTACIEPRO(" + Arrays.toString(parametros) + ")");
	
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					return mensaje;
				}
			});
			mensaje =  matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
		} catch (Exception e) {
			
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en periodo contable ", e);
		}
		return mensaje;		
	}

	/* Lista Principal de los Periodos Contables */
	public List listaPrincipal(PeriodoContableBean periodoContable, int tipoLista) {
		//Query con el Store Procedure
		String query = "call PERIODOCONTABLELIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	
						periodoContable.getNumeroEjercicio(),						
						Constantes.ENTERO_CERO,// periodoID					
						Constantes.ENTERO_CERO,
						tipoLista,
						
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"PeriodoContableDAO.listaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERIODOCONTABLELIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PeriodoContableBean periodoContableBean = new PeriodoContableBean();					
				periodoContableBean.setNumeroEjercicio(String.valueOf(resultSet.getInt(1)));
				periodoContableBean.setNumeroPeriodo(String.valueOf(resultSet.getInt(2)));
				periodoContableBean.setInicioPeriodo(resultSet.getString(3));
				periodoContableBean.setFinPeriodo(resultSet.getString(4));
				periodoContableBean.setFechaCierre(resultSet.getString(5));
				periodoContableBean.setUsuarioCierre(String.valueOf(resultSet.getInt(6)));
				periodoContableBean.setStatus(resultSet.getString(7));
				
				return periodoContableBean;
				
			}
		});
				
		return matches;
	}	
	
	/* Lista por periodo de los Periodos Contables */
	public List listaPorPeriodo(PeriodoContableBean periodoContable, int tipoLista) {
		//Query con el Store Procedure
		String query = "call PERIODOCONTABLELIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	
						periodoContable.getNumeroEjercicio(),						
						periodoContable.getNumeroPeriodo(),			
						Constantes.ENTERO_CERO,
						tipoLista,
						
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"PeriodoContableDAO.listaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERIODOCONTABLELIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PeriodoContableBean periodoContableBean = new PeriodoContableBean();					
				periodoContableBean.setNumeroEjercicio(String.valueOf(resultSet.getInt(1)));
				periodoContableBean.setNumeroPeriodo(String.valueOf(resultSet.getInt(2)));
				periodoContableBean.setInicioPeriodo(resultSet.getString(3));
				periodoContableBean.setFinPeriodo(resultSet.getString(4));
				periodoContableBean.setFechaCierre(resultSet.getString(5));
				periodoContableBean.setUsuarioCierre(String.valueOf(resultSet.getInt(6)));
				periodoContableBean.setStatus(resultSet.getString(7));
				
				return periodoContableBean;
				
			}
		});
				
		return matches;
	}	
	
	/* Lista foranea de los Periodos Contables */
	public List listaForanea(PeriodoContableBean periodoContable, int tipoLista) {
		//Query con el Store Procedure
		String query = "call PERIODOCONTABLELIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	
						periodoContable.getNumeroEjercicio(),						
						Constantes.ENTERO_CERO,// periodoID					
						Constantes.ENTERO_CERO,
						tipoLista,
						
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"PeriodoContableDAO.listaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERIODOCONTABLELIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PeriodoContableBean periodoContableBean = new PeriodoContableBean();		
				periodoContableBean.setNumeroPeriodo(String.valueOf(resultSet.getInt(1)));	
				return periodoContableBean;				
			}
		});
				
		return matches;
	}	
	
	/* Lista por periodo de los Periodos Contables */
	public List listaPorPeriodoNoCerrado(PeriodoContableBean periodoContable, int tipoLista) {
		//Query con el Store Procedure
		String query = "call PERIODOCONTABLELIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	
						periodoContable.getNumeroEjercicio(),						
						Constantes.ENTERO_CERO,			
						Constantes.ENTERO_CERO,
						tipoLista,
						
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"PeriodoContableDAO.listaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERIODOCONTABLELIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PeriodoContableBean periodoContableBean = new PeriodoContableBean();					
				periodoContableBean.setNumeroEjercicio(String.valueOf(resultSet.getInt(1)));
				periodoContableBean.setNumeroPeriodo(String.valueOf(resultSet.getInt(2)));
				periodoContableBean.setInicioPeriodo(resultSet.getString(3));
				periodoContableBean.setFinPeriodo(resultSet.getString(4));
				periodoContableBean.setFechaCierre(resultSet.getString(5));
				periodoContableBean.setUsuarioCierre(String.valueOf(resultSet.getInt(6)));
				periodoContableBean.setStatus(resultSet.getString(7));
				
				return periodoContableBean;
				
			}
		});
				
		return matches;
	}	
	
	/* Consuta Ejercicio Vigente */
	public PeriodoContableBean consultaForanea(PeriodoContableBean periodoContableBean,int tipoConsulta) {
		
		//Query con el Store Procedure
		String query = "call PERIODOCONTABLECON(?,?,?,?, ?,?,?,?,?,?,?);";
		
		Object[] parametros = {
				periodoContableBean.getNumeroEjercicio(),
				periodoContableBean.getNumeroPeriodo(),
				Constantes.FECHA_VACIA,
				Constantes.ENTERO_CERO,
				tipoConsulta,
					
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PeriodoContableDAO.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERIODOCONTABLECON(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {					
				PeriodoContableBean periodoContableBean = new PeriodoContableBean();
				periodoContableBean.setNumeroEjercicio(String.valueOf(resultSet.getInt(1)));
				periodoContableBean.setNumeroPeriodo(resultSet.getString(2));
				periodoContableBean.setInicioPeriodo(String.valueOf(resultSet.getDate(3)));					
				periodoContableBean.setFinPeriodo(String.valueOf(resultSet.getDate(4)));				
				periodoContableBean.setStatus(String.valueOf(resultSet.getString(5)));
					return periodoContableBean;
			}
		});	
		return matches.size() > 0 ? (PeriodoContableBean) matches.get(0) : null;
	}
	
	/* Consuta Estatus del periodo segun fecha  */
	public PeriodoContableBean consultaEstatus(PeriodoContableBean periodoContableBean,int tipoConsulta) {
		
		//Query con el Store Procedure
		String query = "call PERIODOCONTABLECON(?,?,?,?, ?,?,?,?,?,?,?);";
		
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				periodoContableBean.getFecha(),
				Constantes.ENTERO_CERO,
				tipoConsulta,
					
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PeriodoContableDAO.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERIODOCONTABLECON(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {					
				PeriodoContableBean periodoContableBean = new PeriodoContableBean();				
				periodoContableBean.setStatus(String.valueOf(resultSet.getString(1)));
					return periodoContableBean;
			}
		});	
		return matches.size() > 0 ? (PeriodoContableBean) matches.get(0) : null;
	}
	
	

	/* Consuta Fecha para periodo contable  */
	public PeriodoContableBean consultaFechaVig(PeriodoContableBean periodoContableBean,int tipoConsulta) {
		
		//Query con el Store Procedure
		String query = "call PERIODOCONTABLECON(?,?,?,?, ?,?,?,?,?,?,?);";
		
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				periodoContableBean.getFecha(),
				Constantes.ENTERO_CERO,
				tipoConsulta,
					
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PeriodoContableDAO.ConsultaFechVig",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERIODOCONTABLECON(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {					
				PeriodoContableBean periodoContableBean = new PeriodoContableBean();				
				periodoContableBean.setInicioPeriodo(String.valueOf(resultSet.getString(1)));
					return periodoContableBean;
			}
		});	
		return matches.size() > 0 ? (PeriodoContableBean) matches.get(0) : null;
	}
	
public PeriodoContableBean consultaEjercicio(PeriodoContableBean periodoContableBean,int tipoConsulta) {
		
		//Query con el Store Procedure
		String query = "call PERIODOCONTABLECON(?,?,?,?, ?,?,?,?,?,?,?);";
		
		Object[] parametros = {
				periodoContableBean.getNumeroEjercicio(),
				periodoContableBean.getNumeroPeriodo(),
				Constantes.FECHA_VACIA,
				Constantes.ENTERO_CERO,
				tipoConsulta,
					
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PeriodoContableDAO.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERIODOCONTABLECON(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {					
				PeriodoContableBean periodoContableBean = new PeriodoContableBean();
				periodoContableBean.setNumeroEjercicio(String.valueOf(resultSet.getInt("EjercicioID")));
				periodoContableBean.setNumeroPeriodo(resultSet.getString("PeriodoID"));
				periodoContableBean.setInicioPeriodo(String.valueOf(resultSet.getDate("Inicio")));					
				periodoContableBean.setFinPeriodo(String.valueOf(resultSet.getDate("Fin")));				
				periodoContableBean.setStatus(String.valueOf(resultSet.getString("Estatus")));
					return periodoContableBean;
			}
		});	
		return matches.size() > 0 ? (PeriodoContableBean) matches.get(0) : null;
	}
	
}
