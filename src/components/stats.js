import React from "react"

class Stats extends React.Component {
	state = {
		error: false,
		fetchedData: []
	}
	componentDidMount(){
		fetch('https://corona.lmao.ninja/v2/countries/switzerland')
			.then(response => {
				return response.json()
			})
			.then(json => {
				console.log(json)
				this.setState ({
					fetchedData: json
				})
			})
	}

  render(){
		const {fetchedData} = this.state
    return(
			<div className="stats" align="center">
				{fetchedData.country} | 
				Cases: {fetchedData.cases} (today:{fetchedData.todayCases}) |
				Deaths: {fetchedData.deaths} (today:{fetchedData.todayDeaths}) |
				Critical: {fetchedData.critical}
			</div>
		)
  }
}

export default Stats