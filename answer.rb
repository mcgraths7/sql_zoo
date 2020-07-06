def craiglockhart_to_sighthill_subqueries
  # Find the routes involving two buses that can go from Craiglockhart to
  # Sighthill. Show the bus no. and company for the first bus, the name of the
  # stop for the transfer, and the bus no. and company for the second bus.
  execute(<<-SQL)
    SELECT DISTINCT
      start.num,
      start.company,
      transfer.name,
      finish.num,
      finish.company
    FROM
      routes AS start
    JOIN
      stops AS transfer ON transfer.id = start.stop_id
    JOIN
      routes AS finish ON transfer.id = finish.stop_id
    WHERE
      (start.num, start.company) IN (
        SELECT
          num, company
        FROM
          routes
        WHERE
          stop_id IN (
            SELECT
              id
            FROM
              stops
            WHERE
              name = 'Craiglockhart'
          )
      ) AND transfer.id IN (
        SELECT
          stop_id
        FROM
          routes
        WHERE
          routes.num IN (
            SELECT
              num
            FROM
              routes
            WHERE
              routes.stop_id IN (
                SELECT
                  id
                FROM
                  stops
                WHERE
                  name = 'Craiglockhart'
                )
          ) AND routes.company IN (
            SELECT
              company
            FROM
              routes
            WHERE
              routes.stop_id IN (
                SELECT
                  id
                FROM
                  stops
                WHERE
                  name = 'Craiglockhart'
                )
          )
      ) AND transfer.id IN (
        SELECT
          stop_id AS transfer_point
        FROM
          routes
        WHERE
          routes.num IN (
            SELECT
              num
            FROM
              routes
            WHERE
              routes.stop_id IN (
                SELECT
                  id
                FROM
                  stops
                WHERE
                  name = 'Sighthill'
                )
          ) AND routes.company IN (
            SELECT
              company
            FROM
              routes
            WHERE
              routes.stop_id IN (
                SELECT
                  id
                FROM
                  stops
                WHERE
                  name = 'Sighthill'
                )
          )
      ) AND (finish.num, finish.company) IN (
        SELECT
          num, company
        FROM
          routes
        WHERE
          stop_id IN (
            SELECT
              id
            FROM
              stops
            WHERE
              name = 'Sighthill'
          )
      )
  SQL
end