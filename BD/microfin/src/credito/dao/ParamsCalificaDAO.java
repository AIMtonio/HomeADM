package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
 
import credito.bean.ParamsCalificaBean;

public class ParamsCalificaDAO extends BaseDAO{
	public ParamsCalificaDAO() {
		super();
	}
	
	// listaTipos de Direccion Combobox
		public List listaParamsCalificaCombo(int tipoLista){
			String query = "call PARAMSCALIFICALIS(?,?,?,?,?,?,?,?);";
			
			Object[] parametros = {tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ParamsCalificaDAO.listaParamsCalificaCombo",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMSCALIFICALIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
					ParamsCalificaBean paramsCalifica = new ParamsCalificaBean();
					paramsCalifica.setTipoInstitucion(String.valueOf(resultSet.getString(1)));
					return paramsCalifica;				
				}
			});
			return matches;
					
		}

				
}
