package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import originacion.bean.CatlineanegocioBean;


public class CatlineanegocioDAO extends BaseDAO{
	
	public CatlineanegocioDAO() {
		super();
	}
	
	
	
	public List lineasNegocioCombo(int tipoLista){

		String query = "call CATLINEANEGOCIOLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				 
					Constantes.ENTERO_CERO,
					tipoLista,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATLINEANEGOCIOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatlineanegocioBean catlineanegocioBean = new CatlineanegocioBean();
				catlineanegocioBean.setLinNegID(resultSet.getString(1));
				catlineanegocioBean.setLinNegDescri(resultSet.getString(2));
				return catlineanegocioBean;
				
			}
		});
		return matches;
		}
	
	
}
