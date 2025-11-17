<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Agent;
use App\Models\Task;
use App\Models\Tool;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create test user if doesn't exist
        $user = User::firstOrCreate(
            ['email' => 'test@example.com'],
            [
                'name' => 'Test User',
                'password' => bcrypt('password')
            ]
        );

        // Create sample agents
        $agents = [
            [
                'name' => 'Data Analyzer',
                'description' => 'Agent specialized in data analysis and processing',
                'status' => 'idle'
            ],
            [
                'name' => 'Web Scraper',
                'description' => 'Agent for web scraping and data extraction',
                'status' => 'running'
            ],
            [
                'name' => 'Report Generator',
                'description' => 'Agent that generates reports from analyzed data',
                'status' => 'idle'
            ]
        ];

        foreach ($agents as $agentData) {
            $agent = Agent::create($agentData);

            // Create tasks for each agent
            Task::create([
                'agent_id' => $agent->id,
                'title' => 'Process daily logs',
                'description' => 'Analyze and process daily system logs',
                'status' => 'pending',
                'priority' => 7
            ]);

            Task::create([
                'agent_id' => $agent->id,
                'title' => 'Generate summary report',
                'description' => 'Create summary report of processed data',
                'status' => 'completed',
                'priority' => 5
            ]);
        }

        // Create sample tools
        $tools = [
            [
                'name' => 'Data Parser',
                'description' => 'Tool for parsing various data formats',
                'category' => 'data-processing'
            ],
            [
                'name' => 'Web Crawler',
                'description' => 'Tool for crawling websites',
                'category' => 'web-scraping'
            ],
            [
                'name' => 'Report Builder',
                'description' => 'Tool for building formatted reports',
                'category' => 'reporting'
            ]
        ];

        foreach ($tools as $toolData) {
            Tool::create($toolData);
        }
    }
}
