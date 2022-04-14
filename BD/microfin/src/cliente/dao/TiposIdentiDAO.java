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

import cliente.bean.TiposDireccionBean;
import cliente.bean.TiposIdentiBean;

public class TiposIdentiDAO extends BaseDAO {


	
	public TiposIdentiDAO() {
		super();
	}
	

// ------------------ Transacciones ------------------------------------------
	
	//consulta de Tipos de  identificacion

	public TiposIdentiBean consultaPrincipal(int tipoIdenti, int tipoConsulta){
		String query = "call TIPOSIDENTICON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { tipoIdenti,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposIdentiDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSIDENTICON(" + Arrays.toString(parametros) + ")");

		TiposIdentiBean tiposIdenti = new TiposIdentiBean();
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TiposIdentiBean tiposIdenti = new TiposIdentiBean();

				tiposIdenti.setTipoIdentiID(String.valueOf(resultSet.getInt(1)));
				tiposIdenti.setEmpresaID(Utileria.completaCerosIzquierda(resultSet.getLong(2), 10));
				tiposIdenti.setNombre(resultSet.getString(3));
				tiposIdenti.setNumeroCaracteres(String.valueOf(resultSet.getInt(4)));
				tiposIdenti.setOficial(resultSet.getString(5));	

				return tiposIdenti;
			}
		});

		return matches.size() > 0 ? (TiposIdentiBean) matches.get(0) : null;

		}
	
	 public TiposIdentiBean consultaForanea(int tipoIdenti, int tipoConsulta) {
         //Query con el Store Procedure
			String query = "call TIPOSIDENTICON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = { tipoIdenti,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"TiposIdentiDAO.consultaForanea",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSIDENTICON(" + Arrays.toString(parametros) + ")");

			TiposIdentiBean tiposIdenti = new TiposIdentiBean();
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					TiposIdentiBean tiposIdenti = new TiposIdentiBean();

					tiposIdenti.setTipoIdentiID(String.valueOf(resultSet.getInt(1)));
					tiposIdenti.setNombre(resultSet.getString(2));
					

					return tiposIdenti;
				}
			});

			return matches.size() > 0 ? (TiposIdentiBean) matches.get(0) : null;

			}
		

		//Lista de Tipos de identificacion
	public List listaTiposIdenti(TiposIdentiBean tiposIdenti, int tipoLista){
		String query = "call TIPOSIDENTILIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	tiposIdenti.getNombre(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposIdentiDAO.listaTiposIdenti",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSIDENTILIS(" + Arrays.toString(parametros) + ")");
		

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TiposIdentiBean tiposIdenti = new TiposIdentiBean();
				tiposIdenti.setTipoIdentiID(String.valueOf(resultSet.getInt(1)));
				tiposIdenti.setNombre(resultSet.getString(2));
				tiposIdenti.setNumeroCaracteres(String.valueOf(resultSet.getInt(3)));
				
				return tiposIdenti;

			}
		});
		return matches;
	}
	
	// listaTipos de Direccion bombobox
	public List listaTiposIdentifC(int tipoLista){
		String query = "call TIPOSIDENTILIS(?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TiposIdentiDAO.listaTiposIdentifC",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSIDENTILIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				TiposIdentiBean tiposIdenti = new TiposIdentiBean();
				tiposIdenti.setTipoIdentiID(String.valueOf(resultSet.getInt(1)));
				tiposIdenti.setNombre(resultSet.getString(2));
				tiposIdenti.setNumeroCaracteres(resultSet.getString(3));
				return tiposIdenti;				
			}
		});
		return matches;
				
	}

}
