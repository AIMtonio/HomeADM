package cliente.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import javax.sql.DataSource;

import cliente.bean.SectoresBean;

public class SectoresDAO extends BaseDAO{

	public SectoresDAO() {
		super();
	}

	
	/*Consulta Principal para el Sector General del cliente*/
	public SectoresBean consultaPrincipal(SectoresBean sectores, int tipoConsulta){
		String query = "call SECTORESCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { sectores.getSectorID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SectoresDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SECTORESCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				SectoresBean sectores = new SectoresBean();

				sectores.setSectorID(String.valueOf(resultSet.getInt(1)));
				sectores.setDescripcion(resultSet.getString(2));
				sectores.setPagaIVA(resultSet.getString(3));
				sectores.setPagaISR(resultSet.getString(4));

				return sectores;
			}
	    });

		return matches.size() > 0 ? (SectoresBean) matches.get(0) : null;

	}
	
	/*Consulta Foranea para el  Sector General del Cliente*/
	
	public SectoresBean consultaForanea(SectoresBean sectores, int tipoConsulta){
		String query = "call SECTORESCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { sectores.getSectorID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SectoresDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SECTORESCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				SectoresBean sectores = new SectoresBean();

				sectores.setSectorID(String.valueOf(resultSet.getInt(1)));
				sectores.setDescripcion(resultSet.getString(2));
				
				return sectores;
			}
		});

		return matches.size() > 0 ? (SectoresBean) matches.get(0) : null;
	}
	
	/*Lista de Sectores*/
	public List lista(SectoresBean sectores, int tipoLista){
		String query = "call SECTORESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	sectores.getDescripcion(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"SectoresDAO.lista",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SECTORESLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				SectoresBean sectores = new SectoresBean();
				sectores.setSectorID(String.valueOf(resultSet.getInt(1)));
				sectores.setDescripcion(resultSet.getString(2));

				return sectores;

			}
		});
		return matches;
	}

}
