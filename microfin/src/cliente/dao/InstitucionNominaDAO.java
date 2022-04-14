package cliente.dao;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import cliente.bean.InstitucionNominaBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class InstitucionNominaDAO extends BaseDAO{
	public InstitucionNominaDAO(){
		super();
	}
	
public InstitucionNominaBean consultaInstitucion(int tipoConsulta, InstitucionNominaBean institucionBean){
		String query = "call INSTITNOMINACON(" +
				"?,?, ?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(institucionBean.getInstitNominaID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InstitucionNominaDAO.consultaInstitucion",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InstitucionNominaBean institNom = new InstitucionNominaBean();
				institNom.setNombreInstit(resultSet.getString(1));
				
				return institNom;
			}
		});

		return matches.size() > 0 ? (InstitucionNominaBean) matches.get(0) : null;
	}
	/*
	 * Utilizada para WS.
	 */
	public InstitucionNominaBean consultaInstitucionWS(int tipoConsulta, InstitucionNominaBean institucionBean){
		String query = "call INSTITNOMINACON(" +
				"?,?, ?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(institucionBean.getInstitNominaID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InstitucionNominaDAO.consultaInstitucion",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InstitucionNominaBean institNom = new InstitucionNominaBean();
				institNom.setNombreInstit(resultSet.getString(1));
				
				return institNom;
			}
		});

		return matches.size() > 0 ? (InstitucionNominaBean) matches.get(0) : null;
	}

	public InstitucionNominaBean consultaPromotor(int tipoConsulta, InstitucionNominaBean institucionBean){
		String query = "call INSTITNOMINACON(" +
				"?,?, ?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(institucionBean.getInstitNominaID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InstitucionNominaDAO.consultaInstitucion",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINACON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InstitucionNominaBean institNom = new InstitucionNominaBean();
				
				institNom.setPromotorID(String.valueOf(resultSet.getInt("PromotorID")));
				institNom.setNombrePromotor(resultSet.getString("NombrePromotor"));
				institNom.setTelefono(resultSet.getString("Telefono"));
				
				
				return institNom;
			}
		});
		return matches.size() > 0 ? (InstitucionNominaBean) matches.get(0) : null;

	}
	





	public InstitucionNominaBean consultaPromotorWS(int tipoConsulta, InstitucionNominaBean institucionBean){
		String query = "call INSTITNOMINACON(" +
				"?,?, ?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(institucionBean.getInstitNominaID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InstitucionNominaDAO.consultaInstitucion",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINACON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				InstitucionNominaBean institNom = new InstitucionNominaBean();
				
				institNom.setPromotorID(String.valueOf(resultSet.getInt("PromotorID")));
				institNom.setNombrePromotor(resultSet.getString("NombrePromotor"));
				institNom.setTelefono(resultSet.getString("Telefono"));
				
				
				return institNom;
			}
		});

		return matches.size() > 0 ? (InstitucionNominaBean) matches.get(0) : null;

	}
public InstitucionNominaBean consultaCte(int tipoConsulta, InstitucionNominaBean institucionBean){
	String query = "call INSTITNOMINACON(" +
			"?,?, ?,?,?,?,?,?,?,?);";
	Object[] parametros = {
			Utileria.convierteEntero(institucionBean.getInstitNominaID()),
			institucionBean.getClienteID(),
			tipoConsulta,
			
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"InstitucionNominaDAO.consultaInstitucion",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
			};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			InstitucionNominaBean institNom = new InstitucionNominaBean();
			institNom.setInstitNominaID(resultSet.getString("InstitNominaID"));
			institNom.setNombreInstit(resultSet.getString("NombreInstit"));
			return institNom;
		}
	});

	return matches.size() > 0 ? (InstitucionNominaBean) matches.get(0) : null;
}
public InstitucionNominaBean consultaForanea(int tipoConsulta, InstitucionNominaBean institucionBean){
	String query = "call INSTITNOMINACON(" +
			"?,?, ?,?,?,?,?,?,?,?);";
	Object[] parametros = {
			Utileria.convierteEntero(institucionBean.getInstitNominaID()),
			Constantes.ENTERO_CERO,
			tipoConsulta,
			
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"InstitucionNominaDAO.consultaInstitucion",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
			};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INSTITNOMINACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			InstitucionNominaBean institNom = new InstitucionNominaBean();
			institNom.setInstitNominaID(resultSet.getString("InstitNominaID"));
			institNom.setNombreInstit(resultSet.getString("NombreInstit"));
			return institNom;
		}
	});

	return matches.size() > 0 ? (InstitucionNominaBean) matches.get(0) : null;
}
}

